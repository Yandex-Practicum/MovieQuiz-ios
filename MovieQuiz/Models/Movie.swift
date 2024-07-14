//
//  Movie.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 01/11/2023.
//

import Foundation

struct Actor : Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie : Codable {
    let id: String
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]
    
    enum CodingKeys: CodingKey {
        case id, title, year, image, releaseDate, runtimeMins, directors, actorList
    }
    
    enum ParseError: Error {
        case yearFailure
        case runtimeFailure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(String.self, forKey: .image)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        directors = try container.decode(String.self, forKey: .directors)
        actorList = try container.decode([Actor].self, forKey: .actorList)
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else { throw ParseError.yearFailure }
        self.year = yearValue
        let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
        guard let runtimeValue = Int(runtimeMins) else { throw ParseError.runtimeFailure }
        self.runtimeMins = runtimeValue
    }
} 
