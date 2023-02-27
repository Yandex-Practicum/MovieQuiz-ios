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
        increaseGamesCount()
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

    var gamesCount: Int {
        get {
            getGamesCount()
        }
    }

    private func getTotalAccuracy() -> Double {
        let total = userDefaults.integer(forKey: StatisticKeys.total.rawValue)
        if total == 0 {
            return 0.0
        }
        let correct = userDefaults.integer(forKey: StatisticKeys.correct.rawValue)
        return (Double(correct) / Double(total))
    }

    private func setTotalAccuracy(correct count: Int, total amount: Int) {
        let correct = userDefaults.integer(forKey: StatisticKeys.correct.rawValue)
        let total = userDefaults.integer(forKey: StatisticKeys.total.rawValue)
        userDefaults.set(correct + count, forKey: StatisticKeys.correct.rawValue)
        userDefaults.set(total + amount, forKey: StatisticKeys.total.rawValue)
    }

    private func getGamesCount() -> Int {
        userDefaults.integer(forKey: StatisticKeys.gamesCount.rawValue)
    }

    private func increaseGamesCount() {
        userDefaults.set(gamesCount + 1, forKey: StatisticKeys.gamesCount.rawValue)
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
        (amount != 0)
        ? Double(count) / Double(amount)
        : 0.0
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

    private func updateBestGameIfNeeded(correct count: Int, total amount: Int)
    {
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
