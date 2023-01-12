//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 21.12.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<Movies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    // MARK: - NetworkClient
    
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    //MARK: - URL
    
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадет с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_kkq248sh") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    private var top250MoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадет с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_kkq248sh") else {
            preconditionFailure("Unable to construct top250MoviesUrl")
        }
        return url
    }
    
    // MARK: - LoadMovies
    
    func loadMovies(handler: @escaping (Result<Movies, Error>) -> Void) {
        
        var mostPopularMoviesData: Movies?
        var top250MoviesData: Movies?
        var loadError: Error?
        
        let group = DispatchGroup()
        
        group.enter()
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(Movies.self, from: data)
                    mostPopularMoviesData = mostPopularMovies
                    group.leave()
                    
                } catch {
                    loadError = error
                    group.leave()
                }
            case .failure(let error):
                loadError = error
                group.leave()
            }
        }
        
        group.enter()
        networkClient.fetch(url: top250MoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let top250Movies = try JSONDecoder().decode(Movies.self, from: data)
                    top250MoviesData = top250Movies
                    group.leave()
                    
                } catch {
                    loadError = error
                    group.leave()
                }
            case .failure(let error):
                loadError = error
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let loadError = loadError {
                handler(.failure(loadError))
            } else {
                let allMovies = (top250MoviesData?.items ?? [MovieData]()) + (mostPopularMoviesData?.items ?? [MovieData]())
                handler(.success(Movies(errorMessage: "", items: Array(Set(allMovies)))))
            }
        }
    }
}
