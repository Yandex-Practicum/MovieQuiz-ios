//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 16.06.23.
//

import Foundation

protocol StatisticService {
    // геттер - спецификатор, работает как модификатор доступа
    var totalAccuracy: Double { get }//средняя точность прав.отв. за все игры в %
    var gamesCount: Int { get } //кол-во заверш.игр
    var bestGame: GameRecord { get }//лучшая попытка
    
    func store(correct count: Int, total amount: Int) //метод для сохранения текущего результата игры
}

final class StatisticServiceImplementation: StatisticService { //класс для ведения статистики
    
    private let userDefaults = UserDefaults.standard //конст чтобы каждый раз при работе с User Defaults не обращаться к standard
    private enum Keys: String { //ключи для всех сущностей для сохранения в User Defaults через enum, более безопасно т.к. у кейсов можно просто брать rawValue. Тем самым снижается вероятность ошибки в строковых переменных, а ключ будет легче переименовать.
        case correct, total, bestGame, gamesCount
    }
    
    //MARK: Properties //реализовать геттеры и сеттеры для оставшихся свойств
    
    private var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return Double(correct)/Double(total)*100
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
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
            guard let data = try? JSONEncoder().encode(newValue) else { //преобразуем структуру данных (GameRecord будет лежать в переменной newValue) в тип Data
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue) //переменную data нужно просто сохранить в User Defaults
        }
    }
    
    //MARK: Function //реализовать функцию сохранения лучшего результата store (с проверкой на то, что новый результат лучше сохранённого в User Defaults)
    
    func store(correct count: Int, total amount: Int) {
        correct += count // сохранить корректные ответы за все время
        total += amount // сохранить количество вопросов за все время
        gamesCount += 1
        
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
}

