//
// Created by Андрей Парамонов on 12.01.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient: NetworkRouting
    private let mostPopularMoviesUrl: URL

    init(networkClient: NetworkRouting = NetworkClient()) {
        let textUrl = "https://imdb-api.com/en/API/Top250Movies/k_4w0p6ftx"
        guard let url = URL(string: textUrl) else {
            preconditionFailure("Unable to construct url from string: \(textUrl)")
        }
        mostPopularMoviesUrl = url
        self.networkClient = networkClient
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
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
