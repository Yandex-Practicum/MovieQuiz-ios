//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 10.03.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
