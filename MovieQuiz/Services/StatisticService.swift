//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 14.12.2022.
//

import Foundation

// Протокол, чтобы "закрыть" им класс
protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

// Класс для сбора и хранения статистики игр
final class StatisticServiceImplementation: StatisticService {
    
    // Свойство, чтобы сократить написание и не обращаться к .standart
    private let userDefaults = UserDefaults.standard
    
    // Для удобства и безопасности работы с ключами создаем enum
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    // Получаем количество правильных ответов
    var correct: Int {
        return userDefaults.integer(forKey: Keys.correct.rawValue)
    }
    
    // Получаем количество сыгранных игр
    var total: Int {
        return userDefaults.integer(forKey: Keys.total.rawValue)
    }
    
    // Высчитываем процент точности
    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100 * (correctCount / total)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var date = Date()
    
    // Функция хранения лучшего результата
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        
        if bestGame < GameRecord(correct: count, total: amount, date: date) {
            self.bestGame = GameRecord(correct: count, total: amount, date: date)
        } else {
            self.bestGame = bestGame
        }
    }
    
    // Свойство bestGame для считывания и записи лучших результатов
    // Модификатор доступа private(set) для соответствия протоколу
    private(set) var bestGame: GameRecord {
        get { // Получаем текущий лучший результат
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set { // Сохраняем новый лучший результат если актуально
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}
