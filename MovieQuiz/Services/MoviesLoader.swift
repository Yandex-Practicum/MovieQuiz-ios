import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {

    // MARK: - NetworkClient
    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        //Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_2kcic34w") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }

    //функция может вернуть успешный результат загрузки данных или ошибку типа Error.
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        ///Эта строка кода вызывает метод fetch структуры networkClient с URL-адресом, указанным в константе mostPopularMoviesUrl. Метод fetch загружает данные по URL-адресу и передает результат в виде значения типа Result<Data, Error>, используя замыкание.
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result { //значение result будет проверяться на наличие успешной или неуспешной загрузки данных.
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
