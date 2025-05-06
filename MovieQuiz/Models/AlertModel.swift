//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by admin on 04.06.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}

