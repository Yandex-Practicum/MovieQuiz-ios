//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Veniamin on 15.11.2022.
//

import Foundation

//эта модель нужна для записи результатов рекордной игры после ее завершения
struct GameRecord: Codable {
    let correct: Int // количество правильных ответов
    let total: Int //общее число вопросов
    let date: Date //дата прохождения квиза
    
    func compare(source cmpr: GameRecord) -> Bool {
        if (self.correct < cmpr.correct){
            return true
        } else {
            return false
        }
    }
}



protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get } // средняя точность
    var gamesCount: Int { get } // кол-во сыгранных квизов
    var bestGame: GameRecord { get } // рекорд
}



final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard // чтобы каждый раз не обращаться к standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
    }

    var date: Date = Date()
    
    
    func store(correct count: Int, total amount: Int) { // функция сохранения результата с проверкой, что новый результат лучше предыдущих
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        
        if bestGame.compare(source:
                                GameRecord(correct: count, total: amount, date: date)){
            bestGame = GameRecord(correct: count, total: amount, date: date)
        }
    }
    
    
    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100*(correctCount/total)
        }
    }
    

    //сохраним без JSON
    private(set) var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    private(set) var bestGame: GameRecord { // добавляем модификатор доступа private(set), чтобы соответствовать протоколу
        get { // зачитка результатов
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {//запись новых данных
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
}


