//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Andrey Sysoev on 29.09.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
