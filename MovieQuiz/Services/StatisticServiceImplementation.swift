//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 18.12.2023.
//

import UIKit

final class StatisticServiceImplementation: StatisticService {
    
    var gamesRecords: [GameRecord]?
    
    var gamesCount: Int? {
        gamesRecords?.count
    }
    
    var bestGame: GameRecord? {
        gamesRecords?.max(by: { $0.correct < $1.correct })
    }
    
    var totalAccuracy: Double? {
        guard let records = gamesRecords, !records.isEmpty else { return nil }
        let totalAccuracy = records.reduce(0.0) { (acc, record) in
            acc + (Double(record.correct) / Double(record.total))
        }
        return (totalAccuracy / Double(records.count)) * 100.0
    }
    
    // приватный метод, извлекает записи каждой игры из хранилища
    private func getAllGameRecords() -> [GameRecord] {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
        let gameRecordKeys = keys.filter { $0.starts(with: "GameRecord_") }
        var gameRecords = [GameRecord]()

        for key in gameRecordKeys {
            if let data = UserDefaults.standard.data(forKey: key),
               let gameRecord = try? JSONDecoder().decode(GameRecord.self, from: data) {
                gameRecords.append(gameRecord)
            }
        }

        return gameRecords
    }
    
    init() {
        self.gamesRecords = getAllGameRecords()
    }
}
