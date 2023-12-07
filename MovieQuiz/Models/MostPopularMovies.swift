//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 03.12.2023.
//

import Foundation

struct MostPopularMovies:Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie:Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum Keys: String, CodingKey {
        
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
        
    }
}
