//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 08.08.2023.
//

import Foundation

struct NetworkClient {
    
    /// IMDB API KEY
    enum imdbAPIKey: String {
        case myImdbApiKey = "k_ht49n70c"
        case ypImdbApiKey = "k_zcuw1ytf"
        case testImdbApiKey = "k_12345678"
    }
    
    
    /// Возможные ошибки сетевого уровня
    enum NetworkError: Error, LocalizedError{
        case codeError
        case wrongData
        case noData
        
        var errorDescription: String? {
            switch self {
            case .codeError:
                return NSLocalizedString("Не получилось декодировать данные", comment: "Проблема с кодированием")
            case .wrongData:
                return NSLocalizedString("Сервер вернул некорректные данные", comment: "Неверные данные")
            case .noData:
                return NSLocalizedString("Сервер не предоставил даннных", comment: "Нет данных")
            }
        }
    }
    
    /// Запрашиваем данные с сервера
    func fetch (url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        // Подготавливаем HTTPS-запрос
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // В случае возникновении ошибки возвращаем её замыканию
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем успешность HTTPS-запроса
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Проверяем, пришли ли данные с сервера
            guard let data = data else {
                handler(.failure(NetworkError.wrongData))
                return
            }
            
            handler(.success(data))
        }
        
        // Выполняем HTTPS-запрос
        task.resume()
    }
}
