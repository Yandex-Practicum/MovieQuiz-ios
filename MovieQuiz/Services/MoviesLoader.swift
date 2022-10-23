import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_c6ft04mn") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum DecodingError: Error {
        case errorInCode
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .failure(let error): handler(.failure(error))
            case .success(let data):
                let topMovieList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                if let topMovieList = topMovieList {
                    handler(.success(topMovieList)) } else {
                        handler(.failure(DecodingError.errorInCode))
                    }
            }
        }
    }
}
