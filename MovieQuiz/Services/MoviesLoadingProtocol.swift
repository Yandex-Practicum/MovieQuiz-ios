//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Toto Tsipun on 15.12.2022.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
