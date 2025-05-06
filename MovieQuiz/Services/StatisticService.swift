//
//  StatisticServise.swift
//  MovieQuiz
//
//  Created by Артем Чалков on 24.10.2023.
//

import Foundation

protocol StatisticService {
    var message: String { get }
    var gameCount: Int { get set }
    
    var gameStatistic: GameRecord? { get set }
    var recordObject: GameRecord? { get }
    
    func update(model: GameRecord)
    func store()
}

class StatisticServiceImplementation: StatisticService {
    
    var gameCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "GameCount")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "GameCount")
        }
        
    }
    
    var gameStatistic: GameRecord?
   
    var message: String {
        guard let gameStatistic else { return "" }
        
        var recordObject = recordObject ?? gameStatistic
        
        if gameStatistic.isBetterThan(recordObject) {
            recordObject = gameStatistic
        }
        
        var value = """
        Ваш результат: \(gameStatistic.record)
        Количество сыграных квизов: \(gameCount)
        Рекорд: \(recordObject.record) (\(recordObject.currentDate))
        Средняя точность: \(gameStatistic.averageAccuracy)
        """
        
        return value
    }
    
    func update(model: GameRecord) {
        self.gameStatistic = model
    }
    
    var recordObject: GameRecord? {
        
        if let recordData = UserDefaults.standard.data(forKey: "Record") {
            
            let decoder = JSONDecoder()
            do {
                let record = try decoder.decode(GameRecord.self, from: recordData)
                return record
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func store() {
        //1. Model -> Binary
        let jsonEncoder = JSONEncoder()
        
        guard let currentObject = gameStatistic else { return }
        
        do {
    
            if let recordObject = recordObject {
                //if record > current -> break
                if recordObject.isBetterThan(currentObject) {
                    return
                }
            }
            
            //Binary
            let currentData = try jsonEncoder.encode(gameStatistic)
            
            //2. Binary -> UserDefaults
            UserDefaults.standard.set(currentData, forKey: "Record")
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
