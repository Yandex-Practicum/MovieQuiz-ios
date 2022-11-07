
import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


class StatisticServiceImplementation: StatisticService {

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }

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

    private let userDefaults = UserDefaults.standard

    var bestGame: GameRecord {
        get {
            // Загружаю из UserDefaults результаты рекордой игры
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            // Новая лучшая игра
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            // Записал её данные
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct // сравниваю объекты по кол-ву правильных ответов
    }
}



