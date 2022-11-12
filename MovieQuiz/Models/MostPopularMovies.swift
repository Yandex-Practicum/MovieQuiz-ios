//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 11.11.2022.
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
        // создаем строку из адреса
        let urlString = imageURL.absoluteString
        // обрезаем лишню часть и добавляем модификатор
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        // пытаемся создать новый адрес, если не получается, то возвращаем старый
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
