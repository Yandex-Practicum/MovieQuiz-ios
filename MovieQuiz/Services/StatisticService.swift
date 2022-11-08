import Foundation

protocol StatisticService: AnyObject {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Float { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var allResults: [Int] { get }
}

struct GameRecord: Codable, Comparable {
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    let correct: Int
    let total: Int
    let date: Date

}

final class StatisticServiceImplementation: StatisticService {
    
    func store(correct count: Int, total amount: Int) {
        let possibleBestGame = GameRecord(correct: count, total: amount, date: Date())
        if bestGame < possibleBestGame {
            bestGame = possibleBestGame
        }
        allResults.append(count)
    }
    var totalAccuracy: Float {
        let questionsAmount = 10
        let sumOfAllResults = allResults.reduce(0, +)
        let accuracy = Float(sumOfAllResults * 100) / Float(questionsAmount * allResults.count)
        return accuracy
    }
    var gamesCount: Int {
        return allResults.count
    }
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    private(set) var allResults: [Int] {
        get {
            return userDefaults.object(forKey: Keys.allResults.rawValue) as? [Int] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Keys.allResults.rawValue)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case bestGame, allResults
    }
}

