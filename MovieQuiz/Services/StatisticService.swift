
import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    func isNewRecord(current: Int) -> Bool {
        return current > self.correct
    }
}
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct: Int, total: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy
    }
    private (set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить рекорд")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }

    private (set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    private (set) var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
                let accuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                return .init(0.0)
            }
            return accuracy
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить точность")
                return
            }
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }

    func store(correct: Int, total: Int) {
        if self.bestGame.isNewRecord(current: correct) {
            self.bestGame = GameRecord(correct: correct, total: total, date: Date())
        }
        gamesCount += 1
        totalAccuracy = (totalAccuracy * Double(gamesCount - 1) +
        (Double(correct) / Double(total)) * 100) / Double(gamesCount)
    }
}
