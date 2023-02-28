import Foundation


protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get set}
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func gameСomparison(currentCorrect: Int, recordCorrect: Int ) -> Bool {
        currentCorrect > recordCorrect
    }
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        let keyCorrect = Keys.correct.rawValue
        let keyTotal = Keys.total.rawValue
        let keyBestGame = Keys.bestGame.rawValue
        let correctAnswers = userDefaults.integer(forKey: keyCorrect)
        let newCorrectAnswers = correctAnswers + count
        userDefaults.set(newCorrectAnswers, forKey: keyCorrect)
        
        let totalQuestions = userDefaults.integer(forKey: keyTotal)
        let newTotalQuestions = totalQuestions + amount
        userDefaults.set(newTotalQuestions, forKey: keyTotal)
        let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        let newGamesCount = gamesCount + 1
        userDefaults.set(newGamesCount, forKey: Keys.gamesCount.rawValue)
    
        if count > bestGame.correct {
        bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сосчитать кол-во игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    var totalAccuracy: Double {
        get {
            let сorrect = (userDefaults.value(forKey: Keys.correct.rawValue) as? Double) ?? 0
            let questions = (userDefaults.value(forKey: Keys.total.rawValue) as? Double) ?? 0
            return сorrect / questions * 100
        }
        set {
            
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
    
}

