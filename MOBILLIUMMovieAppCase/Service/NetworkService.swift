//
//  NetworkService.swift
//  MOBILLIUMMovieAppCase
//
//  Created by Veysel Bozkurt on 8.03.2022.
//

import Foundation
import Alamofire

enum ServiceType: String{
    case upcoming = "upcoming"
    case mowPlaying = "now_playing"
}

class NetworkService{
    
    static var shared = NetworkService()
    let baseUrl = "https://api.themoviedb.org/3/movie/"
    var pageNumber = 1
    
    func getMovies(service: ServiceType, completion: @escaping ([MovieResultModel]?, String?)-> Void){
        
        let endUrl = baseUrl + "\(service.rawValue)?api_key=7dd354fbedc4932b4863756f9df41e26"
        
        let request = AF.request(endUrl)
        
        request.validate().responseDecodable(of: MovieModel.self) { response in
            switch response.result{
            case .success(let movieInfo):
                completion(movieInfo.results, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func getMoviesUpcoming(service: ServiceType, completion: @escaping ([MovieResultModel]?, String?)-> Void){
        
        let a = "&page=\(pageNumber)"
        
        let endUrl = baseUrl + "\(service.rawValue)?api_key=7dd354fbedc4932b4863756f9df41e26" + a
        
        let request = AF.request(endUrl)
        
        request.validate().responseDecodable(of: MovieModel.self) { response in
            switch response.result{
            case .success(let movieInfo):
                completion(movieInfo.results, nil)
            case .failure(let error):
                debugPrint(error)
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getMoviewDetail(id: Int, completion: @escaping (MovieDetail?, String?) -> Void) {
        
        let endUrl = baseUrl + "\(id)?api_key=7dd354fbedc4932b4863756f9df41e26"
        
        let request = AF.request(endUrl)
        
        request.validate().responseDecodable(of: MovieDetail.self) { response in
            switch response.result{
            case .success(let movieInfo):
                completion(movieInfo, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    
    
}
