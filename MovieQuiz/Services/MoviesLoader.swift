//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Mir on 07.04.2023.
//

import UIKit

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_kcx08h45") else {
            preconditionFailure("Unable to construct mostPopulatMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            
            switch result {
                
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if mostPopularMovies.errorMessage.isEmpty {
                        handler(.success(mostPopularMovies))
                    } else {
                        let error = CustomError.custom(message: mostPopularMovies.errorMessage)
                        handler(.failure(error))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        enum CustomError: Error, LocalizedError {
            case wrongApiKey
            case custom(message: String)
            
            public var errorDescription: String? {
                switch self {
                case .wrongApiKey:
                    return "Wrong API-key"
                case .custom(let message):
                    return message
                }
            }
        }
    }
}
