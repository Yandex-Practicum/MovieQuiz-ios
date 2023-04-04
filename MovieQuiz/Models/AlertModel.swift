//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Василий on 11.06.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
