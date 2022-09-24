// swiftlint:disable all
import UIKit

struct GameRecord: Codable {
    let correct: Int // Правильных ответов
    let total: Int // Всего вопросов
    let date: Date // Дата завершения раунда
}

class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    // Метод для сохранения результатов игры
    func store(correct count: Int, total amount: Int) {
        
        // Проверка на рекорд
        let currentGameResults = GameRecord(correct: count, total: amount, date: Date())
        
        if self.bestGame < currentGameResults {
            self.bestGame = currentGameResults
        }
        
        // Запись общего кол-ва правильных ответов
        let correctStored = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctStored + count, forKey: Keys.correct.rawValue)
        
        // Запись общего кол-ва заданных вопросов
        let totalStored = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(totalStored + amount, forKey: Keys.total.rawValue)
        
        // Запись общего числа сыгранных партий
        let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        userDefaults.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
        
    }
    
    var totalAccuracy: Double {
        guard let correctStored = Double(userDefaults.string(forKey: Keys.correct.rawValue) ?? "0.0"),
              let totalStored = Double(userDefaults.string(forKey: Keys.total.rawValue) ?? "0.0") else {
            return 0.0
        }
        return (correctStored / totalStored) * 100
    }
    
    var gamesCount: Int {
        get {
            guard let gamesCountStored = Int(userDefaults.string(forKey: Keys.gamesCount.rawValue) ?? "0") else {
                return 0
            }
            return gamesCountStored
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

// MARK: - Протоколы и расширения

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct // сравниваю объекты по кол-ву правильных ответов
    }
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get } // В процентах от всех игр, включая текущую
    var gamesCount: Int { get } // Всего сыграно игр, включая текущую
    var bestGame: GameRecord { get } // Рекорд
}
