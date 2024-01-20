import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        let newTotal = self.total + amount
        let newCorrect = self.correct + count
        
        userDefaults.set(newTotal, forKey: Keys.total.rawValue)
        userDefaults.set(newCorrect, forKey: Keys.correct.rawValue)
        
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
        }
        
        gamesCount += 1
    }
    
    var totalAccuracy: Double {
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        return total > 0 ? Double(correct) / Double(total) : 0
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
    
    private var total: Int {
        userDefaults.integer(forKey: Keys.total.rawValue)
    }
    
    private var correct: Int {
        userDefaults.integer(forKey: Keys.correct.rawValue)
    }
}
