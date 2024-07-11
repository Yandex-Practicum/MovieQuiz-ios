//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 10/07/2024.
//

import Foundation

struct MostPopularMovies: Codable {
    var errorMessage: String
    var items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    var title: String
    var rating: String
    var imageURL: URL
    
    var resizedImageURL: URL {
    
            let urlString = imageURL.absoluteString
            let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
            guard let newURL = URL(string: imageUrlString) else {
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
