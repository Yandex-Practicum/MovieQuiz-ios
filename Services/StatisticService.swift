import Foundation


protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
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
        
        if let bestGame = userDefaults.object(forKey: keyBestGame) as? Data,
           let record = try? JSONDecoder().decode(GameRecord.self, from: bestGame),
           record.gameСomparison(currentCorrect: count, recordCorrect: record.correct) {
            let newRecord = GameRecord(correct: count, total: amount, date: Date())
            let data = try? JSONEncoder().encode(newRecord)
            userDefaults.set(data, forKey: keyBestGame)
        } else {
            let firstRecord = GameRecord(correct: count, total: amount, date: Date())
            let data = try? JSONEncoder().encode(firstRecord)
            userDefaults.set(data, forKey: keyBestGame)
        }
    }

    
    
    var gamesCount: Int {
        
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue), let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return gamesCount
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

