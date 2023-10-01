//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кирилл on 01.10.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
