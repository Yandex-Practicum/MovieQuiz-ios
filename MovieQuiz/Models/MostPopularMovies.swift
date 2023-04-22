//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Kuimova Olga on 22.04.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imagenUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newUrl = URL(string: imagenUrlString) else {
            return imageURL
        }
        
        return newUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

