//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 20.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
