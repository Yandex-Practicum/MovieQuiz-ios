//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 01.03.2024.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
