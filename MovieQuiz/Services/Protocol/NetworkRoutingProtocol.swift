//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 10.04.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
