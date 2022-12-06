import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    
    typealias Handler = (Result<[OneMovie],Errors>)->Void
    // MARK: - NetworkClient
    let networkClient: NetworkRouting
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_6nnz4gev") else { preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping Handler) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let converter = FromOptionalResultToNonOptional()
                do {
                    let model = try decoder.decode(MostPopularMoviesResult.self, from: data)
                    guard let errorMessage = model.errorMessage,
                          errorMessage.isEmpty
                    else {
                        handler(.failure(.exceedAPIRequestLimit))
                        return
                    }
                    let items = model.items.compactMap { converter.convert(result: $0) }
                    guard !items.isEmpty else {
                        handler(.failure(.itemsEmpty))
                        return
                    }
                    handler(.success(items))
                } catch {
                    handler(.failure(.parsingError))
                }
            case .failure(let failure):
                handler(.failure(failure))
            }
        }
    }
}

