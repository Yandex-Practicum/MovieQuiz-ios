//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 25.11.2023.
//

import Foundation



protocol StatisticService {
    var totalAccuracy: Double {get}  //В первой строке выводится результат текущей игры.
    var gamesCount: Int {get set}  // Второй — количество завершённых игр
    var bestGame: BestGame? {get set} //Третьей — информация о лучшей попытке.
    
    func store(correct: Int,total: Int)
}



//
//struct GameRecord: Codable {
//    
//    let correct: Int
//    let total: Int
//    let date: Int
//    
//    struct GameRecord: Codable {
//        let correct: Int
//        let total: Int
//        let date: Date
//
//        
//        func isBetterThan(_ another: GameRecord) -> Bool {
//            correct > another.correct
//        }
//    }
//}
//
//
class StatisticServiceImplementation: StatisticService {
    
//    private let userDefaults: UserDefaults
//    
//    init(userDefaults: UserDefaults = .standard) {
//        self.userDefaults = userDefaults
//        
//    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var total: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.total.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.correct.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    var bestGame: BestGame? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
            var bestGame = try? JSONDecoder().decode(BestGame.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return bestGame
        }

        set {
            var data = try? JSONEncoder().encode(newValue) // else {
//                print("Невозможно сохранить результат")
//                return
          //  }

            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct: Int, total: Int) {
        self.correct += 7
        self.total += 7
        self.gamesCount += 1
        
        let currentBestGame = BestGame(correct: self.correct, total: self.total, date: Date())
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}
