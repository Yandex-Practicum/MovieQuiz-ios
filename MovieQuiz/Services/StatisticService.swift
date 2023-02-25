//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 18.02.2023.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}


struct GameRecord: Codable,Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct    }
    
    let correct: Int
    let total: Int
    let date: Date

//struct CurrentGame: Codable {
//        let correct : Int
//        let total: Int
//        let date: Date
//    }
    
    }

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
   
    func store(correct count: Int, total amount: Int) {
        
        
        
        if (count > bestGame.correct) {
            
            
            let gameRecord = GameRecord(correct: count, total: amount, date: Date())
            
            bestGame = gameRecord
        }
        
        
      
        gamesCount = gamesCount + 1
        totalAccuracy = Double (count / gamesCount)
    }
    
    var totalAccuracy: Double {
        get { guard let totalAccuracy = userDefaults.double(forKey:  Keys.total.rawValue) else {  print ("Ноль игр сыграно") }
            
        
            return totalAccuracy
        }
        set {
          userDefaults.set(newValue, forKey: Keys.total.rawValue)
            
            }
        
    }
    
    var gamesCount: Int {
        
        get { guard let gamesCount = userDefaults.integer(forKey:  Keys.gamesCount.rawValue) else {  print ("Ноль игр сыграно")}
            
        
            return  gamesCount
        }
        set {
          userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            
            }
    }
    
    
    
    
    
    
    
    var bestGame: GameRecord{
        get {guard let data = userDefaults.data(forKey:  Keys.bestGame.rawValue), // запрошиваем лучший рекорд
                   let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else { return .init(correct: 0, total: 0, date: Date()) }
            return record
        }
        set { guard let data = try? JSONEncoder().encode(newValue) else { // записываем лучший новый  рекорд в память
            print("Невозможно сохранить результат")
            return
        }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            
        }
        
        
    }
    
    init(totalAccuracy: Double, gamesCount: Int) {
        self.totalAccuracy = totalAccuracy
        self.gamesCount = gamesCount
    }
    
    
    }
