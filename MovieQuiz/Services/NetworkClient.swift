//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 25.12.2022.
//

import Foundation

protocol NetworkRounting { // Отдельный протокол для NetworkClient, для отдельной реализации этого протокола в тестах
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRounting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    // Функция, которая загружает что-то по заранее заданному URL
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем что нам пришел успешный код ответа (код ответа больше 199 и меньше 300)
            if let response = response as? HTTPURLResponse, // "превращаем" response: URLResponse в тип HTTPURLResponse для проверки кода ответа
               response.statusCode < 200 && response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
        
    }
}
