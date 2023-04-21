//
//  TopMoviesModel.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 20.04.2023.
//

import Foundation

struct TopMovies: Decodable {
    let items: [Movie]
}
