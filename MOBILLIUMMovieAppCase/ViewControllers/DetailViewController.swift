//
//  DetailViewController.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    
    var movieID = 0
    var detailViewModel = DetailViewModel()
    var networkService = NetworkService()
    var movie: MovieDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(abc))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkText
        self.navigationItem.title = ""
        
        
        
        detailViewModel.getMovieDetail(movieId: movieID, networkService: networkService) {
            DispatchQueue.main.async {
                self.movie = self.detailViewModel.movieDetail
                self.setupMovieName()
                self.setupMovieImage()
                self.setupReleaseDate()
                self.setupRatingLabel()
                self.setupMovieDescription()
            }
        }
        
        
        
        
        
    }
    
    @objc func abc(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupMovieImage(){
        movieImage.contentMode = .scaleAspectFill
        let baseUrlForPoster = "https://image.tmdb.org/t/p/original"
        let processor = DownsamplingImageProcessor(size: self.movieImage.bounds.size)
        let str = baseUrlForPoster + (movie?.posterPath ?? "")
        self.movieImage.kf.setImage(with: URL(string: str), placeholder: .none, options: [.processor(processor), .scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage], completionHandler: .none)
        movieImage.kf.indicatorType = .activity
    }
    
    func setupReleaseDate(){
        let a = movie.releaseDate.components(separatedBy: "-")
        let b = a.joined(separator: ".")
        releaseDate.text = b
        self.navigationItem.title = movie.title
    }
    
    func setupRatingLabel(){
        ratingLabel.text = "\(movie.voteAverage)/\(10)"
        let a = NSMutableAttributedString(string: ratingLabel.text!)
        
        a.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1), range: NSRange(location:3,length:3))
        ratingLabel.attributedText = a
        
    }
    
    func setupMovieName(){
        movieName.text = movie.title
    }
    
    func setupMovieDescription(){
        movieDescription.text = movie.overview
    }


}
