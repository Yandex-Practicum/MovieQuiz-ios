//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Mikhail Frantsuzov on 14.11.2023.
//

import Foundation

struct AlertModel {
    let tittle: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
