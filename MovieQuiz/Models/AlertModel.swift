//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Виктор Корольков on 25.07.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
