//
//  SliderCell.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import UIKit
import Kingfisher

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    
    class var identifier: String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieImage.contentMode = .scaleAspectFill
        self.movieImage.kf.indicatorType = .activity
    }
    
    func setupCell(movie: MovieResultModel){
        
        let baseUrlForPoster = "https://image.tmdb.org/t/p/original"
        let processor = DownsamplingImageProcessor(size: self.movieImage.bounds.size)
        let str = baseUrlForPoster + (movie.posterPath ?? "")
        self.movieImage.kf.setImage(with: URL(string: str), placeholder: .none, options: [.processor(processor), .scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage], completionHandler: .none)
        
        self.movieName.text = movie.title
        self.movieDescription.text = movie.overview
    }
}
