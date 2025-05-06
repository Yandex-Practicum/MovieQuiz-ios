import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gameCount
    }
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private(set) var correct: Double {
        get {
            userDefaults.double(forKey: Keys.correct.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private(set) var total: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return (correct / total) * 100
        }
    }
    
    var gameCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gameCount.rawValue),
                  let count = try? decoder.decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить игру")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gameCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? decoder.decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(
            correct: count,
            total: amount,
            date: Date()
        )
        
        gameCount += 1
        correct += Double(count)
        total += Double(amount)
        
        if currentGame >= bestGame {
            bestGame = currentGame
        }
    }
}
