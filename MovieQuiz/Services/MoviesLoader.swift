import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    
    typealias Handler = (Result<MostPopularMovies,Error>)->Void
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_6nnz4gev") else { preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping Handler) {
        
        print("loadMovies function called")
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let success):
                
                let mostPopularMovies = decodeData(success)
                guard let mostPopularMovies = mostPopularMovies else {return}
                handler(.success(mostPopularMovies))
                
            case .failure(let failure):
                handler(.failure(failure))
            }
        }
    }
    private func decodeData(_ data: Data) -> MostPopularMovies? {
        
        let decoder = JSONDecoder()
        let model = try? decoder.decode(MostPopularMovies.self, from: data)
        return model
    }
}
