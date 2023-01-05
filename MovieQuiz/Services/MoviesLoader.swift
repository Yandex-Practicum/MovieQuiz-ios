//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 26.12.2022.
//

import Foundation

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularTVs/k_q42xofd0") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
//https://practicum.yandex.ru/learn/ios-developer/courses/be5032c4-b993-440d-8afe-f68940c9bbf9/sprints/75194/topics/2789bd7b-2ca8-45bc-8757-af592f6d4e8a/lessons/ce8fe453-7c3e-458f-8684-a648f435cf1d/
