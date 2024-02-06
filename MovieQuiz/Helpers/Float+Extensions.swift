//
//  Float+Extensions.swift
//  MovieQuiz
//
//  Created by Сергей Баскаков on 06.02.2024.
//

import Foundation

public extension Float {
    static var randomMovieRating: Float {
        let randomFloat = Float.random(in: 1.0...10.0)
        let intVal:Int = Int(randomFloat*10)
        return Float(intVal)/10.0
    }
}
