//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by kamila on 05.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
