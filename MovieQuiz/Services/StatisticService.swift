//
// Created by Андрей Парамонов on 11.01.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable, Comparable {
    static func <(lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }

    let correct: Int
    let total: Int
    let date: Date
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, totalAccuracy, bestGame, gamesCount
    }

    private let userDefaults = UserDefaults.standard

    func store(correct count: Int, total amount: Int) {
        let record = GameRecord(correct: count, total: amount, date: Date())
        if record > bestGame {
            bestGame = record
        }
        totalAccuracy = (totalAccuracy * Double(gamesCount) + Double(count) / Double(amount)) / Double(gamesCount + 1)
        gamesCount += 1
    }

    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: Date())
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

}