//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Soslan Dzampaev on 18.01.2024.
//

import Foundation

struct AlertModel{
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
