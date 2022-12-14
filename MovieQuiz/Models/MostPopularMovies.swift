//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 11.12.2022.
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
        let oldUrlString = imageURL.absoluteString
        let cuttedUrlString = oldUrlString.components(separatedBy: "._")[0]
        let ending = "._V0_UX600_.jpg"
        let newUrlString = "\(cuttedUrlString)\(ending)"
        guard let newURL = URL(string: newUrlString) else {
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
