//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Flymetric on 19.03.2026.
//

import Foundation

/// Отвечает за загрузку данных по URL
struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                print("Ошибка в ответе")
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                print("statusCode : ", response.statusCode)
                print("headers : ", response.allHeaderFields)
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }

            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
            print("data : ", data)
        }
        
        task.resume()
    }
}


