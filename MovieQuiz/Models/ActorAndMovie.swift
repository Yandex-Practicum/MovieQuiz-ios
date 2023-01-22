//
//  ActorAndMovie.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 10.01.2023.
//

import Foundation



do {
    let movie = try JSONDecoder().decode(Movie.self, from: data)
} catch {
    print("Failed to parse: \(error.localizedDescription)")
}
