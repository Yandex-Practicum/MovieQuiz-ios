//
//  StatisticServiceUserDefaults.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 03.12.2022.
//

import Foundation

final class StatisticServiceUserDefaults : StatisticServiceProtocol {

    private let userDefaults = UserDefaults.standard

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        setTotalAccuracy(correct: count, total: amount)
        updateBestGameIfNeeded(correct: count, total: amount)
    }

    var bestGame: GameRecord {
        get {
            getBestGame()
        }
    }

    var totalAccuracy: Double {
        get {
            100.0 * getTotalAccuracy()
        }
    }

    private(set) var gamesCount: Int {
        set {
            userDefaults.set(newValue, forKey: StatisticKeys.gamesCount.rawValue)
        }
        get {
            userDefaults.integer(forKey: StatisticKeys.gamesCount.rawValue)
        }
    }

    private var correct: Int {
        set {
            userDefaults.set(newValue, forKey: StatisticKeys.correct.rawValue)
        }
        get {
            userDefaults.integer(forKey: StatisticKeys.correct.rawValue)
        }
    }

    private var total: Int {
        set {
            userDefaults.set(newValue, forKey: StatisticKeys.total.rawValue)
        }
        get {
            userDefaults.integer(forKey: StatisticKeys.total.rawValue)
        }
    }

    private func getTotalAccuracy() -> Double {
        return (total == 0) ? 0.0 : (Double(correct) / Double(total))
    }

    private func setTotalAccuracy(correct count: Int, total amount: Int) {
        correct += count
        total += amount
    }

    private func getBestGame() -> GameRecord {
        guard
            let data = userDefaults.data(forKey: StatisticKeys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data)
        else {
            return .init(correct: 0, total: 0, date: Date())
        }
        return record
    }

    private func setBestGame(bestGame: GameRecord) {
        guard let data = try? JSONEncoder().encode(bestGame) else {
            print("Невозможно сохранить результат")
            return
        }
        userDefaults.set(data, forKey: StatisticKeys.bestGame.rawValue)
    }

    private func calcAccuracy(correct count: Int, total amount: Int) -> Double {
        (amount != 0) ? Double(count) / Double(amount) : 0.0
    }

    private func calcAccuracy(gameRecord: GameRecord) -> Double {
        calcAccuracy(correct: gameRecord.correct, total: gameRecord.total)
    }

    private func getLastAccuracy() -> Double {
        calcAccuracy(gameRecord: bestGame)
    }

    private func isDoubleEqual(lhs: Double, rhs: Double) -> Bool {
        let delta = 1e-6
        return fabs(lhs - rhs) < delta
    }

    private func updateBestGameIfNeeded(correct count: Int, total amount: Int) {
        let lastAccuracy = getLastAccuracy()
        let accuracy = calcAccuracy(correct: count, total: amount)
        let isEqual = isDoubleEqual(lhs: lastAccuracy, rhs: accuracy)
        if lastAccuracy < accuracy || isEqual {
            setBestGame(bestGame: GameRecord(
                correct: count,
                total: amount,
                date: Date()))
        }
    }

}
