import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    var correct: Int
    var total: Int
    var date: Date
    
}

final class StatisticServiceImplementation: StatisticService {
    
    func store(correct count: Int, total amount: Int) {
        if bestGame.correct/bestGame.total < count/amount {
            bestGame.date = Date()
            bestGame.correct = count
            bestGame.total = amount
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 10, date: Date())
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

    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: Keys.totalAccuracy.rawValue),
                  let accuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0 
            }
            return accuracy
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
        
    }
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy, accuracy
    }
    
}
