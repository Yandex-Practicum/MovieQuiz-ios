//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 27.12.2022.
//

import Foundation

struct MostPopularMovies: Codable { // Добавляем протокол Codable чтобы структура могла принимать JSON
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable { // Добавляем протокол Codable чтобы структура могла принимать JSON
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey { // С протоколом CodingKey указываем, какое поле в JSON соответствует полю в структуре
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

