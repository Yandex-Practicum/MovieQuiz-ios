//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 06.12.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {

      private enum Keys: String { // ключи для работы с userDefaults
          case correct, total, bestGame, gamesCount
      }
      private let userDefaults = UserDefaults.standard //переменная для работы с userDefaults
      private(set) var correct: Int {
          get {
              let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
              return correctAnswers
          }
          set {
              userDefaults.set(newValue, forKey: Keys.correct.rawValue)
          }
      }
      private(set) var total: Int { // общее кол-во заданных вопросов
          get {
              let totalCorrectAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
              return totalCorrectAnswers

          }
          set {
              userDefaults.set(newValue, forKey: Keys.total.rawValue)
          }
      }
      private(set) var gamesCount: Int { // количество всех сыгранных игр
          get {
                let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
                return gamesCount
            }
          set {
              userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
          }

        }
      var totalAccuracy: Double { // правильность ответов в процентном соотношении
          get {
              return (Double(self.correct)/Double(self.total)) * 100
          }

      }

      private(set) var bestGame: GameRecord { // переменная лучшей игры
          get {
              guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                    let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                  return .init(correct: 0, total: 0, date: Date())
              }
              return record
          }
          set {
              guard let data = try? JSONEncoder().encode(newValue) else {
              print("Невозможно сохранить результат!")
                  return

          } // сохраняем переменную data в userDefaults
              userDefaults.set(data, forKey: Keys.bestGame.rawValue)

          }

      }
      // функция для хранения результатов каждого пройденного раунда
      func store(correct count: Int, total amount: Int) {
          self.correct += count
          self.total += amount
          self.gamesCount += 1
          let counter = GameRecord(correct: count, total: amount, date: Date())
          if bestGame.compare(count:counter) { //в случае лучшего результата сохраняем в bestGame
              bestGame = counter
          }
      }
  }

