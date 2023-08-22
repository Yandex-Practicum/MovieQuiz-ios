//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 16.08.2023.
//
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
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
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





//
//
//
//protocol MoviesLoading {
//    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
//}
//
//struct MoviesLoader: MoviesLoading {
//
//    // MARK: - NetworkClient
//     private let networkClient: NetworkClient
//
//     init(networkClient: NetworkClient = NetworkClient()) {
//         self.networkClient = networkClient
//     }
//
//       // MARK: - URL
//       private var mostPopularMoviesUrl: URL {
//           guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
//               preconditionFailure("Unable to construct mostPopularMoviesUrl")
//           }
//           return url
//       }
//
//       func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
//           networkClient.fetch(url: mostPopularMoviesUrl) { result in
//               switch result {
//               case .success(let data):
//                   do {
//                       let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
//                       handler(.success(mostPopularMovies))
//                   } catch {
//                       handler(.failure(error))
//                   }
//               case .failure(let error):
//                   handler(.failure(error))
//               }
//           }
//       }
//   }
    
    
    
//
//
//    // MARK: - API KEY
//    private let apiKey = "k_956619zh"
//
//    // MARK: - NetworkClient
//
//    private let networkClient = NetworkClient()
//
//    // MARK: - URL
//    private var mostPopularMoviesUrl: URL {
//        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
//            preconditionFailure("Unable to construct mostPopularMoviesUrl")
//        }
//        return url
//    }
//
//    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
//        networkClient.fetch(url: mostPopularMoviesUrl) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
//                    handler(.success(mostPopularMovies))
//                }
//                catch {
//                    handler(.failure(error))
//                }
//            case .failure(let error):
//                handler(.failure(error))
//            }
//
//        }
//    }
//}
