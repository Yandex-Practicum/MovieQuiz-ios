//
//import Foundation
//
//final class StatisticServiceImplementation: StatisticService {
//
//    private let userDefaults = UserDefaults.standard
//
//    private enum Keys: String {
//        case correct, total, bestGame, gamesCount
//    }
//
//    private var correct: Double {
//        get {
//            userDefaults.double(forKey: Keys.correct.rawValue)
//        }
//        set {
//            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
//        }
//    }
//
//    private var total: Double {
//        get {
//            userDefaults.double(forKey: Keys.total.rawValue)
//        }
//        set {
//            userDefaults.set(newValue, forKey: Keys.total.rawValue)
//        }
//    }
//
//    var totalAccuracy: Double {
//        get {
//            100 * (correct / total)
//        }
//    }
//
//    var gamesCount: Int {
//        get {
//            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
//        }
//        set {
//            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
//        }
//    }
//
//    var bestGame: GameRecord {
//        get {
//            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
//                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
//            else {
//                return .init(correct: 0, total: 0, date: Date())
//            }
//            return record
//        }
//        set {
//            guard let data = try? JSONEncoder().encode(newValue) else {
//                print("Невозможно сохранить результат")
//                return
//            }
//            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
//        }
//    }
//
//    // MARK: - FUNC STORE
//
//    func store(correct count: Int, total amount: Int) {
//        gamesCount += 1
//
//        let currentGame = GameRecord(
//            correct: count,
//            total: amount,
//            date: Date()
//        )
//
//        if bestGame.correct < currentGame.correct {
//            bestGame = currentGame
//        }
//        correct += Double(currentGame.correct)
//        total += Double(currentGame.total)
//    }
//}
//


import Foundation

struct GameRecord: Codable {
    
    let correct: Int
    let total: Int
    let date: Date
    
}

extension GameRecord: Comparable {
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.total == 0 {
            return true
        }
        let lhsRatio: Double = Double(lhs.correct) / Double(lhs.total)
        let rhsRatio: Double = Double(rhs.correct) / Double(rhs.total)
        
        return lhsRatio < rhsRatio
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

private enum Keys: String {
    case  total, bestGame, gamesCount
}

@propertyWrapper struct UserDefaultsBacked<Value> {
    fileprivate let key: Keys
    let `default`: Value
    var storage: UserDefaults = .standard

    var wrappedValue: Value {
        get { (storage.value(forKey: key.rawValue) as? Value) ?? `default` }
        set { storage.setValue(newValue, forKey: key.rawValue) }
    }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        let newGame = GameRecord(correct: count, total: amount, date: Date())

        if bestGame < newGame {
            bestGame = newGame
        }
        if gamesCount != 0 { // если игра первая то totalAccuracy равно точности в первой игре
            totalAccuracy = (totalAccuracy + (Double(newGame.correct) / Double(newGame.total))) / 2.0 // среднее арифметическое между средней  и новой игрой
        } else {
            totalAccuracy = (Double(newGame.correct) / Double(newGame.total)) // если
        }
        gamesCount += 1
    }
    
    @UserDefaultsBacked(key: .total, default: 0) var totalAccuracy:Double

    @UserDefaultsBacked(key: .gamesCount, default: 0) var gamesCount: Int

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

