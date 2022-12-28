//
//  MovieActorStructure.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 18.10.2022.
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


