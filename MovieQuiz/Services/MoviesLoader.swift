//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 27.09.2023.
//

import Foundation

//Протокол загрузчика фильмов
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

//загручик фильмов который реализует протокол
struct MoviesLoader: MoviesLoading {
    
    // MARK: -Network Client
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    
    // MARK: -URL
    private var mostPopularMoviesUrl: URL {
        // если мы не смогли преобразоватьт строку в url, то приложение упадет с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case.success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case.failure(let error):
                handler(.failure(error))
            }
        }
    }
}
