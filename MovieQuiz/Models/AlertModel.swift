//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Паша Шатовкин on 19.10.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
