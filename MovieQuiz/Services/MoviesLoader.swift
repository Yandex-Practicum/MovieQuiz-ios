import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClien
    private let networkClient = NetworkClient()

    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
         guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_kiwxbi4y") else {
             preconditionFailure("Unable to construct mostPopularMoviesUrl")
         }
         return url
     }
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in switch result {
        case .failure(let error):
            handler(.failure(error))
        case .success(let data):
            if let movies = try? JSONDecoder().decode(MostPopularMovies.self, from: data) {
                handler(.success(movies))
            } else {
                return
            }
        }
        }
    }
    }
