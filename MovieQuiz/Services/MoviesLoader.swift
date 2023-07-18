//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Антон Павлов on 04.07.2023.
//

import Foundation

// Протокол для загрузки фильмов
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

// Структура для загрузки фильмов
struct MoviesLoader: MoviesLoading {

    // MARK: - NetworkClient

    // Создание экземпляра NetworkClient для выполнения сетевых запросов
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
        }

    // MARK: - URL

    // URL для получения списка самых популярных фильмов
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    // Метод загрузки фильмов
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        // Выполнение сетевого запроса для получения данных фильмов
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    // Декодирование данных в модель MostPopularMovies
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
}

