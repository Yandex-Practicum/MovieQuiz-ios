//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Mir on 07.04.2023.
//

import UIKit

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case image = "image"
    }
}
