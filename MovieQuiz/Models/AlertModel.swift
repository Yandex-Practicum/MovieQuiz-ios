//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Туляганов on 20.11.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () ->Void
}
