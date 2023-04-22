//
//  MovieModel.swift
//  MovieQuiz
//
//  Created by Елена Михайлова on 09.04.2023.
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
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]
}
