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
    private let networkClient = NetworkClient()
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_5aqlukrw") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    //MARK: - Метод для загрузки данных
    func loadMovies (headler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                headler(.failure(error))
            case .success(let data):
                //print(String(data: data, encoding: .utf8))
                do{
                    let jsonData = try JSONDecoder().decode( MostPopularMovies.self, from: data )
                    headler(.success(jsonData))
                    print("jsonData: ✅")
                } catch {
                    print("jsonData: ❌")
                }
            }
        }
    }
}

