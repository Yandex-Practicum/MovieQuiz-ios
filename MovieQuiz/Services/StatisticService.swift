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
    
    mutating func recordGame(correct: Int, total: Int, date: Date) {
        
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


class StatisticServiceImplementation: StatisticService {
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
            
            let totalaccuracy = UserDefaults.standard.double(forKey: Keys.total.rawValue)
            return totalaccuracy
        }
        
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: Keys.total.rawValue)
            
        }
        
    }
    
    private(set)  var gamesCount: Int {
        
        get {
            let gamescount = UserDefaults.standard.integer(forKey: Keys.gamesCount.rawValue)
            return gamescount
            
        }
        
        set {
            UserDefaults.standard.set(newValue,forKey: Keys.gamesCount.rawValue)
        }
        
    }
    
    
    
    private(set) var bestGame: GameRecord {
        
        get {
            
            
            guard let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data)
                    
            else {
                
                return .init(correct: 0, total: 0, date: Date())
                
            }
            
            return record
            
        }
        
        set {
            
            
            guard let data = try? JSONEncoder().encode(newValue) else {
                
                assertionFailure("Невозможно сохранить результат")
                
                return
            }
            
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
            
            
        }
    }
    
    private enum Keys: String {
        
        case correct, total, bestGame, gamesCount
    }
    
    
}



