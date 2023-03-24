import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get set }
}
final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private let bestGameKey = "bestGameKey"
    private let gamesCountKey = "gamesCountKey"
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(correct: count, total: amount, date: Date())
        if newGame.isBetter(than: bestGame) {
            bestGame = newGame
        }
        gamesCount += 1
    }
    var totalAccuracy: Double {
        guard let data = userDefaults.data(forKey: bestGameKey),
              let record = try? JSONDecoder().decode(GameRecord.self, from: data)
        else {
            return 0
        }
        return record.total > 0 ? Double(record.correct) / Double(record.total) : 0
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
