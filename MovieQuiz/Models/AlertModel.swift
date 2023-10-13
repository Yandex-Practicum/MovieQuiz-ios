//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Глеб Хамин on 09.10.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
