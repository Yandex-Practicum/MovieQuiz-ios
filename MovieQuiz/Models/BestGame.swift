//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Ренат Саляхов on 13.09.2023.
//

import Foundation

struct BestGame {
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable {
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct / total)
    }
    static func < (Ihs: BestGame, rhs: BestGame) -> Bool {
        Ihs.accuracy < rhs.accuracy
    }
}
