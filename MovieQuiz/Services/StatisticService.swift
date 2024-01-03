//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by admin on 02.01.2024.
//
//
//import Foundation
//
//protocol StatisticService {
//    func store(correct count: Int, total amount: Int)
//    var totalAccuracy: Double { get }
//    var gamesCount: Int { get }
//    var bestGame: GameRecord { get }
//}
//
//final class StatisticServiceImp: StatisticService {
//
//    private let userDefaults = UserDefaults.standard
//    
//    func store(correct count: Int, total amount: Int) {
//        <#code#>
//    }
//    
//    var totalAccuracy: Double
//    
//    var gamesCount: Int
//    
//    var bestGame: GameRecord
//    
//    
//}
//private enum Keys: String {
//    case correct, total, bestGame, gamesCount
//}
//
//var bestGame: GameRecord {
//    get {
//        guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
//              let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
//            return .init(correct: 0, total: 0, date: Date())
//        }
//        return record
//    }
//    set {
//        guard let data = try? JSONEncoder().encode(newValue) else {
//            print("Невозможно сохранить результат")
//            return
//        }
//        userDefaults.set(data, forKey: Keys.bestGame.rawValue)
//    }
//}
