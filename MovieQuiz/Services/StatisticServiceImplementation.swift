//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 24.10.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

    private let userDefaults = UserDefaults.standard

    var totalAccuracy: Double {
        get {
            return (Double(bestGame.correct) / Double(bestGame.total)) * 100
        }
    }

    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                      return .init(correct: 0, total: 0, date: Date().dateTimeString)
                  }
            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) {
        let gameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)

        if bestGame.correct >= gameRecord.correct {
            userDefaults.set(bestGame.correct, forKey: Keys.bestGame.rawValue)
            userDefaults.set(bestGame.total, forKey: Keys.bestGame.rawValue)
            userDefaults.set(bestGame.date, forKey: bestGame.date)
        } else  {
            print("Невозможно сохранить результат")
        }
    }
}

struct GameRecord: Codable {
    let correct: Int
     let total: Int
     let date: String

     static func isBest(current: GameRecord, previous: GameRecord) -> Bool {
        return current.correct > previous.correct
    }
}
