//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 16.01.2023.
//

import UIKit

struct MostPopularMovies {
    let errorMessage: String
    let items: [MostPopularMovies]
}

struct MostPopularMovie {
    let title: String
    let rating: String
    let imageURL : URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
