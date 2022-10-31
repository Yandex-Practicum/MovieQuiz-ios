import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private let userDefaults = UserDefaults.standard
    var totalAccuracy = Double()
    var correctAnswersAllTheTime: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.correctAnswersAllTheTime.rawValue)
            return count
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correctAnswersAllTheTime.rawValue)
        }
    }
    var questionsAllTheTime: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.questionsAllTheTime.rawValue)
            return count
        }
        set {
            userDefaults.set(newValue,forKey: Keys.questionsAllTheTime.rawValue)
        }
    }
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount)
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }

    var bestGame: GameRecord {                              //Лучшая игра.
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
    var gamesQuizCount: Int {                                   //количество игр.
        get {
            let count = userDefaults.integer(forKey:Keys.gamesCount.rawValue)
            return count
        }
        set {
            userDefaults.set(newValue,forKey: Keys.gamesCount.rawValue)
        }
    }
}
private enum Keys: String {
    case correct, total, bestGame, gamesCount, correctAnswersAllTheTime, questionsAllTheTime
}
