//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 01.08.2023.
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
    
    var resizedImage: URL {
        let urlString = imageURL.absoluteString
        
        let imageURLString = urlString.components(separatedBy: "._")[0] + "._V0_UX600.jpg"
        
        guard let newURL = URL(string: imageURLString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
