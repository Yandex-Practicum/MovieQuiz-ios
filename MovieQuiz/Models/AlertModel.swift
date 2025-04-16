//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Роман Ивановский on 10.07.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}

