//
//  Movie.swift
//  MovieQuiz
//
//  Created by Иван Иванов on 10.01.2023.
//

import Foundation

struct Actor {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}
struct Movie {
    let id: String
    let rank: String
    let title: String
    let year: String
    let image: String
    let releaseDate: String
    let runtimeMins: String
    let directors: String
    let actorList: [Actor]
} 
