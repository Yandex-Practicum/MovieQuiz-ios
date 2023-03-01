//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 18.02.2023.
//

import Foundation
/*
 
 /*
   сравнивать рез-т текущей игры с рекордом из UserDefaults
  обновить рекорд если лучше
  
  
  
  
  
  
  
  
  
  
  
  
  */ */
protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get set }
    var gamesCount: Int { get set }
    var bestGame: GameRecord { get set }
}

private enum Keys: String {
    case correct, total, bestGame, gamesCount, totalAccuracy
}


struct GameRecord: Codable,Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct    }
    
    let correct: Int
    let total: Int
    let date: Date

    
    }

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    var overAllQuestions:Double = 0
    var totalCorrectAnswers:Double = 0
    
    func store(correct count: Int, total amount: Int) {
        
        
        if (count > bestGame.correct) {
            
            let gameRecord = GameRecord(correct: count, total: amount, date: Date())
            
            bestGame = gameRecord
        }
       
        overAllQuestions = overAllQuestions + Double(amount)
        
        totalCorrectAnswers = totalCorrectAnswers + Double(count)
        
        gamesCount += 1
        
        totalAccuracy = (totalCorrectAnswers / overAllQuestions)
        
    }
    
    var totalAccuracy: Double {
        get {
            let totalAccuracyValue = userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
           
            return 100 * totalAccuracyValue
        }
  
          set {
              userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
  
      }
    
    var gamesCount: Int {
        
        get { return userDefaults.integer(forKey:  Keys.gamesCount.rawValue) }
            
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
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
