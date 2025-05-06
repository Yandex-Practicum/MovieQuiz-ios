//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Калько on 26.09.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
