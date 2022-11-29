//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Respect on 28.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    private enum DecodeError: Error {
        case codeError
        case invalidCharacter
    }
    
    // MARK: - Network Client
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_q8w9sd9g") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler:  { result in
                    switch result {
                    case .failure(let error):
                        handler(.failure(error))
                        
                    case .success(let data):
                        let mostPopularMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                        if let mostPopularMovies = mostPopularMovies {
                            if mostPopularMovies.items.isEmpty {
                            handler(.failure(DecodeError.invalidCharacter))
                           } else {
                               handler(.success(mostPopularMovies)
                               )
                           }
                        } else {
                            handler(.failure(DecodeError.codeError))
                }
            }
        })
    }
}

