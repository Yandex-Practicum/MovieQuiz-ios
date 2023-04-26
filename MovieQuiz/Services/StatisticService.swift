import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var total: Int { get }
    var correct: Int { get }

}




final class StatisticServiceImplemintation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard

    var totalAccuracy: Double {
        get {
            guard total > 0 else { return 0 }
            return ((Double(correct) / Double(total) * 100))
        }
    }

    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        } set {
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

    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }

    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newGameRecord = GameRecord (correct: count,
                                        total: amount,
                                        date: Date())
        if bestGame < newGameRecord {
            bestGame = newGameRecord
        }
        gamesCount += 1
        correct += count
        total += amount
    }
}
