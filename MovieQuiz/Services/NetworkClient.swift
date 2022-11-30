//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Veniamin on 22.11.2022.
//

import Foundation
/// Отвечает за загрузку данных по URL
/// сетевой клиент для получения данных с API IMDb
struct NetworkClient{
    
    private enum NetworkError: LocalizedError{
        
        case codeError(code: Int)
        
        var errorDescription: String? {
            switch self {
            case .codeError(let code):
                return "Код ошибки - \(code)"
            }
        }
    }
    
    //функция забирает данные из сети, отдает результат асинхронно через замыкание handler
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void ){ //Result  -  это  enum с двумя состояниями (success, failure), где success принимает любые ассоциированные данные
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            //data, response, error - опциональные, поэтому их надо распаковать
            
            // Проверяем, пришла ли ошибка
            if let error = error{
                handler(.failure(error))//Result.failure(error)
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {//HTTPURLResponse - это наследник URLResponse, класс URLResponce - базовый класс для работы со всеми сетевыми протоколами
                handler(.failure(NetworkError.codeError(code: response.statusCode)))
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data)) // данные возвращаются с использованием handler
            
        }
        task.resume() //  запуск нашего запроса
        
    }
    
}
