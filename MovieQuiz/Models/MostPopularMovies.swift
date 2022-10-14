//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 13.10.2022.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageUrl: URL
    
    var resizedImageUrl: URL {
        let urlString = imageUrl.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newUrl = URL(string: imageUrlString) else {
            return imageUrl
        }
        
        return newUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageUrl = "image"
    }
}
