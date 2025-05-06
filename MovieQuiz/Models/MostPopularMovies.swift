//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 04.01.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
