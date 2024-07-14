//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 05/11/2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        get {
            if total == 0 { return 0.0 }
            return Double(correct) / Double(total) * 100
        }
    }
    
    var total: Int {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.total.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                print("Problem with total")
                return 0
            }
            return count
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.correct.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                print("Problem with correct")
                return 0
            }
            return count
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.gamesCount.rawValue),
                  let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            return count
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: getDate()) }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount, date: getDate())
        if currentGame.compareTwo(prevRec: bestGame) {
            bestGame = currentGame
        }
        gamesCount += 1
        self.correct += count
        self.total += amount
    }
    
    // ДЛЯ РЕВЬЮЕРА. Я не понял как пользоваться dateTimeString из раздела Helpers, поэтому сделал отдельную функцию
    // Если вы мне объясните, буду очень признателен ^^
    func getDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}
