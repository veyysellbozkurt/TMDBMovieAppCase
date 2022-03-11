//
//  UpcomingCustomCell.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import UIKit
import Kingfisher

class UpcomingCustomCell: UITableViewCell {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    
    
    class var identifier: String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        self.movieImage.kf.indicatorType = .activity
        
    }
    
    
    func setupCell(movie: MovieResultModel){
        let baseUrlForPoster = "https://image.tmdb.org/t/p/w500"
        let processor = DownsamplingImageProcessor(size: self.movieImage.bounds.size)
        let str = baseUrlForPoster + (movie.posterPath ?? "")
        self.movieImage.kf.setImage(with: URL(string: str), placeholder: .none, options: [.processor(processor), .scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage], completionHandler: .none)
        
        self.movieImage.layer.cornerRadius = 8
        self.movieImage.contentMode = .scaleAspectFill
        
        self.movieDate.text = setupDateFormat(date: movie.releaseDate)
        self.movieDescription.text = movie.overview
        self.movieName.text = movie.title
        
        
    }
    
    func setupDateFormat(date: String) -> String{
        let splitArray = date.components(separatedBy: "-")
        let newStringArray = splitArray.joined(separator: ".")
        return newStringArray
    }
}
