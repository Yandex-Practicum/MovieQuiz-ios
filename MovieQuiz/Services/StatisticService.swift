import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

//MARK: - Class Statistic
final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard

//MARK: - Enum
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
//MARK: - Function
    
    func store(correct count: Int, total amount: Int) {
        let currentGameResults = GameRecord(correct: count, total: amount, date: Date())

        if self.bestGame < currentGameResults {
            self.bestGame = currentGameResults
        }

        let correctStored = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctStored + count, forKey: Keys.correct.rawValue)

        let totalStored = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(totalStored + amount, forKey: Keys.total.rawValue)

        userDefaults.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
    }

    var totalAccuracy: Double {
        let correctStored = userDefaults.double(forKey: Keys.correct.rawValue)
        let totalStored = userDefaults.double(forKey: Keys.total.rawValue)
        return (correctStored / totalStored) * 100
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
}

// MARK: - GameRecord
struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    init(correct: Int, total: Int, date: Date) {
        self.correct = correct
        self.total = total
        self.date = date
    }
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}



