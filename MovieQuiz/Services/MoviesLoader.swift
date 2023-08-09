//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 08.08.2023.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

///
struct MoviesLoader: MoviesLoaderProtocol {
    
    private let networkClient = NetworkClient()
    
    /// Формируем URL HTTPS-запроса
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/\(NetworkClient.imdbAPIKey.ypImdbApiKey.rawValue)") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
                
            case .success(let data):
                do {
                    let moviesHeap = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if moviesHeap.items.count == 0 {
                        if !moviesHeap.errorMessage.isEmpty {
                            print(moviesHeap.errorMessage)
                        }
                        throw NetworkClient.NetworkError.noData
                    }
                    handler(.success(moviesHeap))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
