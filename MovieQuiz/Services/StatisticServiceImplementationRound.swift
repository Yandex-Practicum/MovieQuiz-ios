//
//  StatisticServiceImplementationRound.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 20.12.2023.
//

import UIKit

final class StatisticServiceImplementationRound: StatisticService {

    private let gameInfo: GameRecord?
    
    // метод сохраняет результат раунда в хранилище UserDefault
    func store() {
        let key = createUniqueKeyForGameRecord()
        do {
            let data = try JSONEncoder().encode(gameInfo)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Ошибка при сохранении GameRecord: \(error)")
        }
    }
    
    // приветный метод для создания ключа по которому будет хранится результат раунда
    private func createUniqueKeyForGameRecord() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return "GameRecord_\(dateFormatter.string(from: Date()))"
    }
    
    init(currentGame gameInfo: GameRecord?) {
        self.gameInfo = gameInfo
    }
}
