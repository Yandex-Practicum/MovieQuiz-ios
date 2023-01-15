//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 09.01.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let image: URL
    let rating: String
    
    var resizedImageUrl: URL {
        let stringURL = image.absoluteString
        let imageURLString = stringURL.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageURLString) else { return image }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case image = "image"
    }
}
