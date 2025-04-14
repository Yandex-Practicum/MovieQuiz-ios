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
    
    var finalImageUrl: URL {
        let modifiedUrlString = imageURL.absoluteString
        let updatedUrlString = modifiedUrlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let url = URL(string: updatedUrlString) else { return imageURL }
        return url
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
        
    }
}
