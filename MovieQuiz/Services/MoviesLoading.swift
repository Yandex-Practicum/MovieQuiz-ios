//
//  MoviesLoading.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 26.12.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
