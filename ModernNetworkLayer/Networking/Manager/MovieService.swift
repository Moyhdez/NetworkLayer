//
//  MovieService.swift
//  ModernNetworkLayer
//
//  Created by Moises Hernandez Zamarripa on 29/09/20.
//  Copyright © 2020 cjapps. All rights reserved.
//

import Foundation

class MovieService: NetworkManager {
    static let enviroment: NetworkEnviroment = .production
    static let movieAPIKey = "7b692bb4f615f7a9c27b36097d5189e0"
    var router: Router<MovieApi>
    
    init(router: Router<MovieApi>) {
        self.router = router
    }
    
    func getNewMovies(page: Int, completion: @escaping (Result<MovieApiResponse, NetworkError>)->()) {
        router.request(.newMovies(page: page)) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.custom(error: error?.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetwork(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    do {
                        let apiResponse = try MovieApiResponse(responseData)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(NetworkError.unableToDecode))
                    }
                case .failure(let networkError):
                    completion(.failure(networkError))
                }
            }
        }
    }
}
