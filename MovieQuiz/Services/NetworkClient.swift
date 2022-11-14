//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/7/22.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch (url: URL, handler: @escaping (Result <Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        // Таск на GET запрос с API IDMb
        let task  = URLSession.shared.dataTask(with: request) { ( data, response, error ) in
            // проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // проверяем, что пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // возвращаем данные
            guard let data = data else { return }
            print(data)
            handler(.success(data))
            
        }
        task.resume()
    }
}
