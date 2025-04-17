//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Денис Петров on 17.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
