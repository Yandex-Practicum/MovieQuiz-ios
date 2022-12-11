//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 11.12.2022.
//

import Foundation

protocol MoviesLoading {

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)

}

struct MoviesLoader: MoviesLoading {

    private let networkClient = NetworkClient()

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(
                        MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private var mostPopularMoviesUrl: URL {
        let url = "https://imdb-api.com/en/API/Top250Movies/k_kiwxbi4y"
        guard let url = URL(string: url) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

}
