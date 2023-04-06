import Foundation

protocol StatisticService {
    
    // MARK: - Properties
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get set }
    
    // MARK: - Methods
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
    private let bestGameKey = "bestGameKey"
    private let gamesCountKey = "gamesCountKey"
    
    var totalAccuracy: Double {
        let total = Double(bestGame.total)
        return total > 0 ? Double(bestGame.correct) / total : 0
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: gamesCountKey)
        }
        set {
            userDefaults.set(newValue, forKey: gamesCountKey)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: bestGameKey),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return GameRecord(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: bestGameKey)
        }
    }
    
    // MARK: - Methods
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        if newGame.isBetter(than: bestGame) {
            bestGame = newGame
        }
        gamesCount += 1
    }
}

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    func isBetter(than other: GameRecord) -> Bool {
        return correct > other.correct
    }
}
