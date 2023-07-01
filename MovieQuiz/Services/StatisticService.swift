import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    var correct: Int { get }
    var total: Int { get }
}


final class StatisticServiceImplementation: StatisticService {
    var total: Int = 0
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var correct: Int {
            get {
                userDefaults.integer(forKey: Keys.correct.rawValue)
            }
            set {
                userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            }
        }
    
    var totalAccuracy: Double {
        if total == 0 { return 0 }
        return (Double(total) / Double(correct)) * 100
    }
    
    var gamesCount: Int {
            get {
                userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
            set (gamesCount) {
                userDefaults.set(gamesCount, forKey: Keys.gamesCount.rawValue)
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
        func store(correct count: Int, total amount: Int) {
            correct += count
            gamesCount += 1
            total += amount
            let newGame = GameRecord(correct: count, total: amount, date: Date())
            if newGame.correct > bestGame.correct {
                bestGame = newGame
            }
        }
    }

