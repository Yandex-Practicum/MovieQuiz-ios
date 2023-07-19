//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Антон Павлов on 04.07.2023.
//

import Foundation

// Структура для клиента сетевых запросов
struct NetworkClient {

    // Перечисление для ошибки сетевого запроса
    private enum NetworkError: Error {
        case codeError
    }

    // Метод для выполнения сетевого запроса
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        // Создание задачи URLSession для выполнения сетевого запроса
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            // Проверка наличия ошибки
            if let error = error {
                handler(.failure(error))
                return
            }

            // Проверка HTTP-ответа на код статуса вне диапазона 200-299
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }

            // Проверка наличия данных
            guard let data = data else { return }

            // Передача данных через успешный результат
            handler(.success(data))
        }

        // Запуск задачи URLSession
        task.resume()
    }
}
