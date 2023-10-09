//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation

struct NetworkClient {
    
    //MARK: - Private Properties
    
    private enum NetworkError: Error {
        case codeError
    }
    
    //MARK: - Public Methods
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
