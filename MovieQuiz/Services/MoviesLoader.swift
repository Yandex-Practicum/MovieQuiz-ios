//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by macOS on 14.10.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_2td5xl16") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum DecodeError: Error {
        case codeError
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
                
            case .success(let data):
                let movieList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                
                if let movieList = movieList {
                    handler(.success(movieList))
                } else {
                    handler(.failure(DecodeError.codeError))
                }
            }
        }
    }
}
