
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
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_jc9jdg1b") //верный ключ k_jc9jdg1b
        else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum DecodeError: Error {
        case decodeError
        case invalidCharacter
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
                
            case .success(let data):
                let mostPopularMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                
                if let mostPopularMovies = mostPopularMovies {
                    if mostPopularMovies.items != [] {
                    handler(.success(mostPopularMovies))
                    } else {
                        handler(.failure(DecodeError.invalidCharacter))
                    }
                } else {
                    handler(.failure(DecodeError.decodeError))
                }
            }
        })
    }
}
