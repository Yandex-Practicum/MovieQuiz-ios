//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Vladimir Vinakheras on 17.12.2023.
//

import Foundation
import UIKit

protocol StatisticService{
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
