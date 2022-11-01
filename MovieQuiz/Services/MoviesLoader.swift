import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_h7m0bhlk") else {
            preconditionFailure("Невозможно преобразовать mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl){ result in
            switch result{
            case.success(let data):
                do
                {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                }catch let error{
                    handler(.failure(error))
                }
            case.failure(let error):
                handler(.failure(error))
            }
        }
    }
}


