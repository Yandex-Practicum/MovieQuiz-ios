//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Andrey Ovchinnikov on 11.01.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: String
    
    func comparisonRecords(pastResults: GameRecord, newResults: GameRecord) -> Bool {
        pastResults.correct < newResults.correct
    }
}
