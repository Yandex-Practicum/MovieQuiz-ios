//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Антон Павлов on 04.07.2023.
//

import Foundation

// Структура для хранения информации о наиболее популярных фильмах
struct MostPopularMovies: Codable {
    let errorMessage: String  // Сообщение об ошибке
    let items: [MostPopularMovie]  // Массив объектов MostPopularMovie
}

// Структура для хранения информации о конкретном наиболее популярном фильме
struct MostPopularMovie: Codable {
    let title: String  // Название фильма
    let rating: String  // Рейтинг фильма
    let imageURL: URL  // URL-адрес изображения фильма

    // Вычисляемое свойство для измененного URL-адреса изображения
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"

        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }

        return newURL
    }

    // Перечисление для ключей, используемых при сериализации/десериализации
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
