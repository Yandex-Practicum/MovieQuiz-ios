//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 27.09.2023.
//

import Foundation

//создаем протокол для network client
protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}




/// Отвечает за занрузку данных по URL
struct NetworkClient: NetworkRouting {
    
    //создали реализацию протокола Error чтобы обозначить его на тот случай, если произойдет ошибка, создав enum с одним кейсом
    private enum NetworkError: Error {
        case codeError
    }
    
    // Функция запроса, которая будет загружать что-то по зараннее заданному протоколу URL
    func fetch(url: URL, handler: @escaping(Result<Data, Error>) -> Void) {
        
        //Создаем запрос из url и начинаем обработку ответа
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //проверяем пришла ли ошибка
            //распаковываем ошибку
            if let error = error {
                handler(.failure(error))
                return
            }
            
            //проверяем что нам пршел успешный код ответа
            //Обрабатываем код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            //возвращаем данные
            //Обрабатываем успешный ответ
            guard let data = data else {return}
            handler(.success(data))
        }
        
        task.resume()
    }
}
