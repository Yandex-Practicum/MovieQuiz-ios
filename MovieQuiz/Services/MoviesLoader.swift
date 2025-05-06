//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.12.2023.
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
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    //    Нам остаётся реализовать загрузку фильмов в методе loadMovies. Для этого:
    //    Используйте переменные networkClient и mostPopularMoviesUrl.
    //    В замыкании обработайте ошибочное состояние и передайте его дальше в handler.
    //    Преобразуйте данные в MostPopularMovies, используя JSONDecoder.
    //    Верните их, используя handler.
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        let networkClient = NetworkClient()
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    // в параметрах функции у нас замыкание handler - обработчик. Это замыкание, в котором содержится тип Result, он выглядит так:
    //        public enum Result<Success, Failure> where Failure : Error {
    //            case success(Success) -  успех
    //            case failure(Failure) - провал
    //        }
    // Запись Result<MostPopularMovies, Error> означает, что нам вернется либо успех с данными типа MostPopularMovies, либо ошибка.
    
    // (handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
