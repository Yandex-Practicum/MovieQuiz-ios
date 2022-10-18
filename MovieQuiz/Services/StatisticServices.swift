import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
    
    func store(correct count: Int, total amout: Int) -> String
}

final class StatisticServiceImplementation: StatisticService {
    
    enum Keys: String {
       case correct, total, bestGame, gamesCount
    }
    
    private var userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
            (Double(userDefaults.integer(forKey: Keys.correct.rawValue)) / Double(userDefaults.integer(forKey: Keys.total.rawValue))) * 100
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
    
    func store(correct count: Int, total amout: Int) -> String {
        
        let newCorrect = (userDefaults.integer(forKey: Keys.correct.rawValue)) + count
        let newTotal = (userDefaults.integer(forKey: Keys.total.rawValue)) + amout
        
        userDefaults.set(newCorrect, forKey: Keys.correct.rawValue)
        userDefaults.set(newTotal, forKey: Keys.total.rawValue)
        
        let currentRecord = GameRecord(correct: count, total: amout, date: Date())
        if currentRecord.compareGameRecord(recordGR: bestGame) {
            bestGame = currentRecord
        }
        
        if gamesCount >= 0 {
            gamesCount += 1
        }
        
        return "Ваш результат: \(count) / \(amout)\nКоличество сыграных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", totalAccuracy))%"
    }
    

}
