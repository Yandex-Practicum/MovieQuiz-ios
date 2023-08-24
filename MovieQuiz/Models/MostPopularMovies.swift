//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 08.08.2023.
//
import Foundation

/// JSON-модель данных о фильмах, получаемых с IMDB-сервера
struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

/// Модель фильмов из массива items получаемых с сервера
struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
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
