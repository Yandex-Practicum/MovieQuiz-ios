//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Admin on 20.05.2023.
//

import Foundation

/// структура для алерта
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
