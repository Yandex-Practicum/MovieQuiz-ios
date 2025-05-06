//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 06.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
