//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 19.07.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let alertId: String
    let completion: () -> Void
}
