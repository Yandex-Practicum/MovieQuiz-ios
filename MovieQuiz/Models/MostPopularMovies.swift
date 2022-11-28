//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Respect on 28.11.2022.
//

import Foundation

//MARK: - Модель данных

struct MostPopularMovies: Codable {
    let errorMassage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageUrl: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._VO_UX600_.jpg"
        
        guard let newUrl = URL(string: imageUrlString) else {
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
