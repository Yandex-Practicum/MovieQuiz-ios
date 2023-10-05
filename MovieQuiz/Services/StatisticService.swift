//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by LERÄ on 19.09.23.
//

import Foundation

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

    // метод сравнения по кол-ву верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        Double(totalCurrentCount) / Double(totalAnswersCount) * 100
    }
    
    var totalCurrentCount: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
            //userDefaults.removeObject(forKey: Keys.correct.rawValue)
            //userDefaults.synchronize()
        }
    }
    var totalAnswersCount: Int{
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
            //userDefaults.removeObject(forKey: Keys.total.rawValue)
            //userDefaults.synchronize()
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            //userDefaults.removeObject(forKey: Keys.gamesCount.rawValue)
            //userDefaults.synchronize()
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        } set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            //userDefaults.removeObject(forKey: Keys.bestGame.rawValue)
            //userDefaults.synchronize()
        }
    }
    
    func store(correct: Int, total: Int) {
        
        gamesCount += 1
        totalCurrentCount += correct
        totalAnswersCount += total
        
        let currentGame = GameRecord(correct: correct, total: total, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
