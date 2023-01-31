import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get } // новый тип данных GameRecord, нужен, чтобы записывать в него результат одной игры и сохранять его в User Defaults.
    
}

// MARK: - StatisticServiceImplementation

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var correct: Int {
        return userDefaults.integer(forKey: Keys.correct.rawValue)
    }
    
    private var total: Int {
        return userDefaults.integer(forKey: Keys.total.rawValue)
    }

    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100 * (correctCount / total)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var date = Date()

    // MARK: - FUNC STORE
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        if bestGame < GameRecord(correct: count, total: amount, date: date) {
            self.bestGame = GameRecord(correct: count, total: amount, date: date)
        } else {
            self.bestGame = bestGame
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: date)
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

