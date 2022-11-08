//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/7/22.
//

import Foundation

protocol MoviesLoading {
    func loadMovies (headler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    
    private enum NetworkError: Error {
        case codeError
    }
    // Экземпляр класса
    private let networkClient = NetworkClient()
    // URL для топ 250 фильмов в API IDMb
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_5aqlukrw") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    private var dataFromServer: MostPopularMovies
    private let result: (MostPopularMovies, NetworkError)
    //
    func loadMovies (headler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                headler(.failure(error))
            case .success(let data):
                guard let jsonData = try? JSONDecoder().decode( MostPopularMovies.self, from: data ) else { return }
                headler(.success(jsonData))
            }
        }
    }
}

