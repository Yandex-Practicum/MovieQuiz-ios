//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Olga Vasileva on 18.06.2023.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let actionButton: () -> Void
}
