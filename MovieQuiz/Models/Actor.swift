//
//  ActorModel.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 20.04.2023.
//

import Foundation

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}
