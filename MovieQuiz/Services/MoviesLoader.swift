//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 25.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_adn67lp5") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch let error {
                    handler(.failure(error))
                }
            }
        }
    }
    
}

// Александра, можете подсказать, как этот код можно выполнить через guard - else. Пробовал - не получилось 

//func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
//    networkClient.fetch(url: mostPopularMoviesUrl) { result in
//        switch result {
//        case .failure(let error):
//            headler(.failure(error))
//        case .success(let data):
//            guard let jsonData = try? JSONDecoder().decode(MostPopularMovies.self, from: data) else {
//                // Вернуть ошибку в handler
//                return
//            }
//            headler(.success(jsonData))
//        }
//    }
//}

    
