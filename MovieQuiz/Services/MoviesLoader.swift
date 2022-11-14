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
//MARK: - Enum for errors
    
    private enum NetworkError: Error {
        case codeError
        case jsonErrorMessage(String)
        
        // добавляем Error Handler
        var localizedDescription: String {
            switch self {
                // в который передадим error message из JSON
            case .jsonErrorMessage(let message):
                return message
            default:
                return "Uncknown error"
            }
        }
    }
//MARK: - Network client
    
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    // создаём URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_5aqlukrw") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
//MARK: - Метод для загрузки данных
    
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        // передаём URL сетевому клиенту
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            // в случае ошибки, передаём её в handler
            switch result {
            case .failure(let error):
                handler(.failure(error))
            // в случае успеха
            case .success(let data):
                
                do{
                    // парсим JSON
                    let jsonData = try JSONDecoder().decode( MostPopularMovies.self, from: data )
                    
                    // на случай, если в JSON будет присутствовать сообщение об ошибке (например исчерпан дневной лимит запросов)
                    if !jsonData.errorMessage.isEmpty {
                        handler(.failure(NetworkError.jsonErrorMessage(jsonData.errorMessage)))
                        print("jsonData: \(jsonData.errorMessage) ❌")
                        } else {
                    // в случае, если данные успешно декодированы и нет сообщения об ошибке, передаём данные в handler
                        print("jsonData: ✅")
                        handler(.success(jsonData))
                    }
                    
                } catch let mappingError {
                    // в случае возникновения ошибки, передаём её в handler
                    handler(.failure(mappingError))
                    print("jsonData: ❌")
                }
            }
        }
    }
}


