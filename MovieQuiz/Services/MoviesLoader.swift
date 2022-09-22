import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}


struct MoviesLoader: MoviesLoading {
    // MARK: - Network Client
    private let networkClient = NetworkClient()

    //MARK: - URL
    private var mostPopularMoviesURL: URL {
        //Если мы не смогли преобразовать строку в ЮРЛ, то приложение упадет с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularMovies/k_2kcic34w")
        else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(
            url: mostPopularMoviesURL) { result in
                switch result {
                case .failure(let error):
                    handler(.failure(error))
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let movies = try decoder.decode(
                            MostPopularMovies.self,
                            from: data)
                        handler(.success(movies))
                    } catch {
                        handler(.failure(error))
                    }
                }

        }
    }
}



