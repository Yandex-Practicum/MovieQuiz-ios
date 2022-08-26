import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_kiwxbi4y") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        let films = networkClient.fetch(url: mostPopularMoviesUrl, handler: { result in
            switch result {
                case .success(let rawData):
                    print("OK")
                    do {
                        let tmp = try JSONDecoder().decode(MostPopularMovies.self, from: rawData)
                        handler(.success(tmp))
                    } catch {
                        print ("Failed to parse: \(error.localizedDescription)")
                    }
                case .failure(let error) :
                    handler(.failure(error))
            }
        })
    }
}
