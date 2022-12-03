//
//  StatisticServiceUserDefaults.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 03.12.2022.
//

import Foundation

final class StatisticServiceUserDefaults : StatisticServiceProtocol {

    private let userDefaults = UserDefaults.standard

    private var totalAccuracyPrivate: Double = 0.0

    func store(correct count: Int, total amount: Int) {
        setTotalAccuracy(correct: count, total: amount)
        increaseGamesCount()
        updateBestGameIfNeeded(correct: count, total: amount)
    }

    var bestGame: GameRecord {
        get {
            getBestGame()
        }
    }

    var totalAccuracy: Double {
        get {
            totalAccuracyPrivate
        }
    }

    var gamesCount: Int {
        get {
            getGamesCount()
        }
    }

    private func setTotalAccuracy(correct count: Int, total amount: Int) {
        totalAccuracyPrivate = calcAccuracy(correct: count, total: amount)
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
        : 0
    }

    private func calcAccuracy(gameRecord: GameRecord) -> Double {
        calcAccuracy(correct: gameRecord.correct, total: gameRecord.total)
    }

    private func getLastAccuracy() -> Double {
        calcAccuracy(gameRecord: bestGame)
    }

    private func isDoubleLess(lhs: Double, rhs: Double) -> Bool {
        let delta = 1e-6
        return fabs(lhs - rhs) > delta
    }

    private func updateBestGameIfNeeded(correct count: Int, total amount: Int)
    {
        if isDoubleLess(
            lhs: getLastAccuracy(),
            rhs: calcAccuracy(correct: count, total: amount)) {
            setBestGame(bestGame: GameRecord(
                correct: count,
                total: amount,
                date: Date()))
        }
    }

}
