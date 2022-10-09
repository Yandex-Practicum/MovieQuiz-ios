// swiftlint:disable all

import UIKit

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    private enum LoaderError: Error {
        case apiError(String)
    }
    
    
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_eek1onk5") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .success(let data):
                do {
                    let JSONtoStruct = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    
                    if !JSONtoStruct.errorMessage.isEmpty {
                        handler(.failure(LoaderError.apiError(JSONtoStruct.errorMessage)))
                    } else {
                        handler(.success(JSONtoStruct))
                    }
                    
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
