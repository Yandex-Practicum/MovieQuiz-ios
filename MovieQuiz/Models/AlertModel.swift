//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Рамиль Аглямов on 16.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)?
}
