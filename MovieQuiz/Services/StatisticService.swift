//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 20.12.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var total: Int { get set }
    var correct: Int { get set }
}

final class StatisticServiceImplementation {
    private let dateProvider: () -> Date
    
    init(dateProvider:  @escaping ()-> Date = {Date()} ){
        self.dateProvider = dateProvider
    }
}

extension StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.total.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correct: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.correct.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        return Double(correct) / Double(total) * 100
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                  let bestGame = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return bestGame
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvider()
        let currentBestGame = GameRecord(correct: correct, total: total, date: date)
        
        if currentBestGame.isBetterThan(bestGame) {
            bestGame = currentBestGame
        }
    }
    
    
}
