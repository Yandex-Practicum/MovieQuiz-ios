import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
    
}

struct MoviesLoader: MoviesLoading {
    
    //MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    //MARK: - URL
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zft8228h") else {
            preconditionFailure("Не удалось создать MostPopularMoviesURL")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
                
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch let error {
                    handler(.failure(error))
                }
            }
        }
    }
}
