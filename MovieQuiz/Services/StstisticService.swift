//
//  StstisticService.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 20.11.2022.
//

import Foundation



struct GameRecord: Codable {
    
    var correct: Int
    
    var total: Int
    
   var date: Date
    
    mutating func gamerecord(correct: Int, total: Int, date: Date) {
        
        if self.correct < correct {
            
            self.correct = correct
            
            self.total = total
            
            self.date = date
        }
        
        
        
    }
    
    
    
}


 protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    
     var totalAccuracy: Double {get}
    
    var gamesCount: Int {get}
    
    var bestGame: GameRecord {get}
    
}


class SatisicServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int) {
       
        if count >= bestGame.correct {
            
            bestGame.correct = count
            
            bestGame.date = Date()
            

        }
        
        gamesCount += 1
        
        totalAccuracy += (Double(count)/Double(amount))
        

        
    }
    
 private(set) var totalAccuracy: Double {
        get {
            
            guard let data = UserDefaults.standard.data(forKey: Keys.total.rawValue),
                    
                    let totalaccuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                
                return .init(0)
            }
            
            return totalaccuracy
        }
        
        
        set {
            
          guard let data = try? JSONEncoder().encode(newValue) else {
                
                print("Невозможно сохранить результат")
                
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.total.rawValue)
            
            
        }
        
    }
    
  private(set)  var gamesCount: Int {
        
        get {
            
            guard let data = UserDefaults.standard.data(forKey: Keys.gamesCount.rawValue),
                  
                    let gamescount = try? JSONDecoder().decode(Int.self, from: data) else {
                
                return .init(0)
            }
            
            return gamescount
            
        }
        
        set {
            
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.gamesCount.rawValue)
            
        }
        
    }
    
    private enum Keys: String {
        
        case correct, total, bestGame, gamesCount
    }
    
    private(set) var bestGame: GameRecord {
        
        get {
            
            
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                  let recordw = try? JSONDecoder().decode(GameRecord.self, from: data)
                    
            else {
                
                return .init(correct: 0, total: 0, date: Date())
                
            }
            
            return recordw
            
        }
        
        set {
            
            
            guard let data = try? JSONEncoder().encode(newValue) else {
                
                print("Невозможно сохранить результат")
                
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
            
            
        }
    }
    
    
}



