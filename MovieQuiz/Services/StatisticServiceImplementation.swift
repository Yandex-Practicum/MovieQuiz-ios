import Foundation

class StatisticServiceImplementation: StatisticServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let total = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            return total
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат!")
                return
            }
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return gamesCount
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
                print("Невозможно сохранить результат!")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let accuracy = Double(count) / Double(amount)
        if accuracy > totalAccuracy {
            totalAccuracy = accuracy
        }
        bestGame = GameRecord(correct: count, total: amount, date: Date())
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}
