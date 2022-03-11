//
//  DetailViewModel.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import Foundation

class DetailViewModel{
    
    
    var networkService: NetworkService!
    var movieDetail: MovieDetail!
    
    
    func getMovieDetail(movieId: Int, networkService: NetworkService, completion: @escaping() -> ()){
        
        self.networkService = networkService
        networkService.getMoviewDetail(id: movieId) { movieDetail, str in
            guard let movieDetail = movieDetail else {
                return
            }
            self.movieDetail = movieDetail
            DispatchQueue.main.async {
                completion()
            }
        }
        
        
        
    }
    
}
