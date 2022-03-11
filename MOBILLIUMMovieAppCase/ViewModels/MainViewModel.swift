//
//  MainViewModel.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 9.03.2022.
//

import Foundation

class MainViewModel{
    
    
    var networkService: NetworkService!
    var upcomingMovies = [MovieResultModel]()
    var nowPlayingMovies = [MovieResultModel]()
    
    func getUpcomingMovies(networkService: NetworkService, completion: @escaping() -> ()){
        self.networkService = networkService
        networkService.getMoviesUpcoming(service: .upcoming) { movies, str in
            guard let movies = movies else {
                return
            }
            self.upcomingMovies += movies
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getNowPlayingMovies(networkService: NetworkService, completion: @escaping() -> ()){
        self.networkService = networkService
        networkService.getMovies(service: .mowPlaying) { movie, st in
            guard let movie = movie else {
                return
            }
            self.nowPlayingMovies += movie
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    
    
}

