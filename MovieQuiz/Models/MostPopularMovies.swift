//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Veniamin on 23.11.2022.
//

import Foundation

// модель данных для получения лучших фильмов
struct MostPopularMovies: Codable{
    let errorMessage: String
    let items: [MostPopularMovie]
}



struct MostPopularMovie: Codable{ // Codable подключаем для изменения имен полей, тк в данных с api имена другие
    
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey{ //CodingKey - класс, который задает ключи кодировки/перекодировки
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    
    
}
