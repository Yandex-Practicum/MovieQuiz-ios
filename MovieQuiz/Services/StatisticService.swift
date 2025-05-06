import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrect += count
        totalQuestions += amount
        
        let newResult = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < newResult {
            bestGame = newResult
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
    var totalCorrect: Int {
        get {
            userDefaults.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }
    
    var totalQuestions: Int {
        get {
            userDefaults.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            Double(totalCorrect)*100/Double(totalQuestions)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
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
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy, accuracy, totalQuestions, totalCorrect
    }
    
}
