import Foundation

// MARK: - Initializers

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {                      // Расширение для сравнения 2-х структур GameRecord
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    static func <= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct <= rhs.correct
    }
    static func >= (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct >= rhs.correct
    }
    static func > (lhs: GameRecord , rhs: GameRecord) -> Bool {
        return lhs.correct > rhs.correct
    }
}


final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard // создали userDefaults, чтобы не обращаться UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount, date: Date()) //создаем текущей игры (для сравнения)
        
        if bestGame < currentGame {
            bestGame = currentGame
        }
        
        if gamesCount == 0 {  // для 1-й игры точность равна точности первой игры
            totalAccuracy = (Double(currentGame.correct) / Double(currentGame.total))
        } else {            // для остальных игр точность среднее ариф. = (общее+текущее)/2
            totalAccuracy = (totalAccuracy + (Double(currentGame.correct) / Double(currentGame.total))) / 2.0
        }
        gamesCount += 1
    }
    
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        set { // сохраняем в userDefaults общую точность
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set { // сохраняем в userDefaults общее кол-во игр
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
