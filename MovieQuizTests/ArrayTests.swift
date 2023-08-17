////
////  ArrayTests.swift
////  ArrayTests
////
////  Created by Марат Хасанов on 11.08.2023.
////
//
//import XCTest
//
//struct MoviesLoader: MoviesLoading {
//    // MARK: - NetworkClient
//    private let networkClient = NetworkClient()
//
//    // MARK: - URL
//    private var mostPopularMoviesUrl: URL {
//        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_kiwxbi4y") else {
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
//                } catch {
//                    handler(.failure(error))
//                }
//            case .failure(let error):
//                handler(.failure(error))
//            }
//        }
//    }
//}
