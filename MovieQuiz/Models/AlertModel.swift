//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation

struct AlertModel {
    let text: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
