//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Mishana on 27.06.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
