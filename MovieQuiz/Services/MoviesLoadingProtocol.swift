//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
