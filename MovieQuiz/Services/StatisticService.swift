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
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    
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
                  let record = try? jsonDecoder.decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 10, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? jsonEncoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let accuracy = userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
            return accuracy
        }
        set {
            guard let data = try? jsonEncoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        
        set {
            guard let data = try? jsonEncoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
        
    }
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy, accuracy
    }
    
}
