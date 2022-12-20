
import Foundation

struct MoviesLoader: MoviesLoading {
  private let networkClient = NetworkClient()
  private var mostPopularMoviesUrl: URL {
    guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_ymnm5i4d") else {
      preconditionFailure("Unable to construct mostPopularMoviesUrl")
    }
    return url
  }
  
  func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
    networkClient.fetch(url: mostPopularMoviesUrl) { result in
      switch result {
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

protocol MoviesLoading {
  func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
