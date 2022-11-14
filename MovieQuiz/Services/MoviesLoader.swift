//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 11.11.2022.
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
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_uvl3rav2") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // MARK: - Метод загрузки
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            
            case .success(let data):
                let record = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                guard let record = record else { return }
                handler(.success(record))
            
            case .failure(let error):
                handler(.failure(error))
                return
            }
        }
    }
}
