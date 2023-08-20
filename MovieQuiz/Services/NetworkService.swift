//
//  NetworkService.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 16.08.2023.
//
import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
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
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}

struct ApiErrorMessage: LocalizedError {
    var errorDescription: String?
    
    init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}
