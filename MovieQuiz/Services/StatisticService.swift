//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ренат Саляхов on 13.09.2023.
//

import Foundation
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    // var: best game 
}
