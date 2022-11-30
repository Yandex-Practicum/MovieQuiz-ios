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
    
    enum ErrorList: LocalizedError{
        case imageError
        
        var errorDescription: String? {
            switch self {
            case .imageError:
                return "Ошибка с загрузкой изображения"
            }
        }
    }
    
    
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient() // инициализируем сетевой клиент для загрузки данных
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_dy1rd1bs") else { //k_dy1rd1bs
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) { // загрузчик
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                let dataJSON = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                guard let dataJSON = dataJSON else { return }
                handler(.success(dataJSON)) // используем хендлер для отправки данных
                return
            case .failure(let error):
                handler(.failure(error))
                return
            }
        }
        
    }
}
