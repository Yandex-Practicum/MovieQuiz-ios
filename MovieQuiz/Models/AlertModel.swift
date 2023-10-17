//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Bakhadir on 28.09.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
