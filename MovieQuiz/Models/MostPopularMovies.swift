//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/7/22.
//

import Foundation

struct MostPopularMovies: Decodable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Decodable {
    let crew: String
    let fullTitle: String
    let id: String
    let rating: String
    let ratingCount: String
    let imageURL: URL
    let rank: String
    let title: String
    let year: String
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case crew = "crew"
        case fullTitle = "fullTitle"
        case id = "id"
        case rating = "imDbRating"
        case ratingCount = "imDbRatingCount"
        case imageURL = "image"
        case rank = "rank"
        case title = "title"
        case year = "year"
    }
}

