//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 07.12.2023.
//

import Foundation

/// Отвечает за загрузку данных по URL
struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        // fetch- получить
        //handler - обработчик. Это замыкание, в котором содержится тип Result, он выглядит так:
//        public enum Result<Success, Failure> where Failure : Error {
//            case success(Success) -  успех
//            case failure(Failure) - провал
//        }
        // Запись Result<Data, Error> означает, что нам вернется либо успех с данными типа Data, либо ошибка.
        let request = URLRequest(url: url) // создаем сам запрос из url
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in // создали задачу на оттправление запроса в сеть
            // обрабатываем ответ от сервера: проверяем, пришла ли ошибка,
            if let error = error { // распаковываем ошибку
                handler(.failure(error)) // это то же самое что и Result.failure(error)
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse, // приводим наш response - ответ к виду, соответсттвующему стандарту  HTTP, превращаем наш response в объект класса HTTPURLResponse.
                response.statusCode < 200 || response.statusCode >= 300 { // успешный ли результат узнаем по коду
                handler(.failure(NetworkError.codeError))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            // ЭТО ВСЕ РЕАЛИЗАЦИЯ ОШИБКИ NetworkError.
            // Возвращаем реализацию в качестве ошибки проверки кода:
            guard let data = data else { return } //
            handler(.success(data))
        }
        
        task.resume() // resume - итог. Это встроенная функция URLSessionTask.
    }
}
