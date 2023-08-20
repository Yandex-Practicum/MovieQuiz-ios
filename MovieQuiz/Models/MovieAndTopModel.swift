//
//  MovieAndTopModel.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 20.08.2023.
//

import Foundation
// Модель данных для фильма
struct Movie: Codable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
}
// Модель данных для списка фильмов
struct Top: Decodable {
    let items: [Movie]
}
