//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 25.11.2022.
//

import Foundation

struct  MostPopularMovies: Codable {
    let errorMessage: String
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
