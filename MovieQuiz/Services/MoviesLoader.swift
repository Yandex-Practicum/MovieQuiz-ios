//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/7/22.
//

import Foundation

protocol MoviesLoading {
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    private enum NetworkError: Error {
        case codeError
        case errorMessage (text: String)
    }
    private let networkClient = NetworkClient()
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_5aqlukrw") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    //MARK: - Метод для загрузки данных
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do{
                    let jsonData = try JSONDecoder().decode( MostPopularMovies.self, from: data )
                    // На случай, если в JSON будет присутствовать сообщение об ошибке (например исчерпан дневной лимит запросов)
                    if !jsonData.errorMessage.isEmpty {
                        handler(.failure(NetworkError.errorMessage(text: jsonData.errorMessage)))
                        print("jsonData: \(jsonData.errorMessage) ❌")
                    } else {
                        print("jsonData: ✅")
                        handler(.success(jsonData))
                    }
                } catch let mappingError {
                    handler(.failure(mappingError))
                    print("jsonData: ❌")
                }
            }
        }
    }
}


