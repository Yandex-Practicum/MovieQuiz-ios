//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Артем Чалков on 24.10.2023.
//

import Foundation

import UIKit

struct GameRecord: Codable {
    //var gameCount: Int = 1 //kolichestvo igr
    var questionsCount: Int = 10 //kolichestvo vseh voprosov
    var validCount: Int = 6 //kolichestvo pravilnih
    var date: Date = Date()
    
    var record: String {
        return "\(validCount)/\(questionsCount)"
    }
    
    var percent: Double {
        return Double(questionsCount) / 100 //0.1
    }
    
    var averageAccuracy: String {
        if percent != 0 {
            let average = Double(validCount) / percent
            let formatted = String(format: "%.2f", average)
            return formatted + "%"
        }
        return ""
    }
    
    var currentDate: String {
        return date.dateTimeString
    }
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        validCount > another.validCount
    }
    
}
