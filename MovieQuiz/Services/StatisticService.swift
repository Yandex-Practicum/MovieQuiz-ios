// swiftlint: disable all
import Foundation
protocol StatisticService {

    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }

    func store(correct count: Int, total amoint: Int)

}

final class StatisticServiceImplementation: StatisticService {

    func store(correct count: Int, total ammont: Int) {
        gamesCount += 1

        let gameAccuracy = Double(count) / Double(ammont)
        totalAccuracy = ((totalAccuracy * Double(gamesCount - 1) + gameAccuracy) / Double(gamesCount))

        let bestScore = bestGame.correct
        if count > bestScore {
            let newBestGame = GameRecord(correct: count, total: ammont, date: Date())
            bestGame = newBestGame
        }
    }

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

    private let userDefaults = UserDefaults.standard

    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue )
        }
    }

    private(set) var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }

    private(set) var bestGame: GameRecord {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return GameRecord(correct: 0, total: 0, date: Date())
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



