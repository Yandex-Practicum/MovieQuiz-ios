//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 03.12.2023.
//

import Foundation

protocol MoviesLoaderProtocol {
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) -> Void)
    
}

struct MovieLoader: MoviesLoaderProtocol {
    
    private let networkClient = NetworkClient()
    private var mostPopularMoviesUrl: URL {
        
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else{
            preconditionFailure("Невозможно сформировать ссылку mostPopularMoviesUrlf")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { uploadedData in
            switch uploadedData {
            case .success(let data) :
                do {
                    let decodedData = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(decodedData))
                } catch {
                    print("Ошибка декодирования")
                    handler(.failure(error))
                }
            case.failure(let error) :
                handler(.failure(error))
            }
        }
    }
        
}
