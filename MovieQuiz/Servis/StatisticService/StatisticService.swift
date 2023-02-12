import Foundation

// MARK: - Private Enum Keys

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

// MARK: - StatisticServiceImplementation

final class StatisticServiceImplementation: StatisticService {
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - Private Set Computed Property
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set{
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    // MARK: - Computed Property
    
    var totalAccuracy: Double {
        get {
            let correct = userDefaults.double(forKey: Keys.correct.rawValue)
            let total = userDefaults.double(forKey: Keys.total.rawValue)
            let result = (correct / total) * 100
            return result.rounding(before: 2)
        }
    }
    
    // MARK: - Methods
    
    func store(correct count: Int, total amount: Int) {
      let gameRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if self.bestGame < gameRecord {
            self.bestGame = gameRecord
        }
        
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correct + count, forKey: Keys.correct.rawValue)
        
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(total + amount, forKey: Keys.total.rawValue)
        
        userDefaults.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }
}
