//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Veniamin on 23.11.2022.
//

import Foundation
//сервис для загрузки данных с использованием NetworkClient с преобразованием их в модель MostPopularMovies


//протокол для загрузчика фильмов
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}



struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient() // инициализируем сетевой клиент для загрузки данных
    
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_dy1rd1bs") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) { // загрузчик
        
        let data =  networkClient.fetch(url: mostPopularMoviesUrl) { error in
            
            guard let error = error else {return}
            handler(.failure(error))
            return
            
        }
            
        
        let dataJSON = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
        handler(.success(dataJSON)) // используем хендлер для отправки данных
        return
    }
}
