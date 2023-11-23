import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}


class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        
        get {
            let correctSaved = userDefaults.double(forKey: Keys.correct.rawValue)
            let totalSaved = userDefaults.double(forKey: Keys.total.rawValue)
            return (correctSaved / totalSaved) * 100
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
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        
        if ((bestGame.isBetter(newGame)) ) {
            bestGame = newGame
        }
        gamesCount += 1
        
        let correctSaved = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctSaved + count, forKey: Keys.correct.rawValue)
        
        let totalSaved = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(totalSaved + amount, forKey: Keys.total.rawValue)
    }
}
