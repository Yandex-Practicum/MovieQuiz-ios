//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Gennadii Kulikov on 05.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
