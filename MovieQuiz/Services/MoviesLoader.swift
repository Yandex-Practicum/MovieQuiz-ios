//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Marina on 31.10.2022.
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
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_6f8pl21k") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // Мы стучимся в интернет, в метод Fetch мы передаем замыкание (из-за его определения), обрабатываем либо данные, либо ошибку.
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data) // Преобразуйте данные в MostPopularMovies, используя JSONDecoder
                    handler(.success(movies))    // Верните их, используя handler.
                } catch let error {
                    handler(.failure(error))     // Верните их, используя handler.
                }
            case .failure(let error):
                handler(.failure(error)) // В замыкании обработайте ошибочное состояние и передайте его дальше в handler.
                
            }
        }
        
    }
}
//        Нам остаётся реализовать загрузку фильмов в методе loadMovies. Для этого:
//        Используйте переменные networkClient и mostPopularMoviesUrl.
//        В замыкании обработайте ошибочное состояние и передайте его дальше в handler.
//        Преобразуйте данные в MostPopularMovies, используя JSONDecoder.
//        Верните их, используя handler.
