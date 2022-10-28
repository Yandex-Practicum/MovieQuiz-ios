import Foundation


final class StatisticServiceImplementation: StatisticService {

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

    private let userDefaults = UserDefaults.standard

    private var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }

    private var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }

    var totalAccuracy: Double {
        get {
            return (Double(correct) / Double(total)) * 100
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
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
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

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correct += count
        total += amount

        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if (bestGame <= newRecord) {
            bestGame = newRecord
        }
    }

}
