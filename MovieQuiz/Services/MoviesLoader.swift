//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 14.03.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
           // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
           guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
               preconditionFailure("Unable to construct mostPopularMoviesUrl")
           }
           return url
       }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopulaerMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopulaerMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
