//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Daud Tsechoev on 07.05.2024.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: () -> Void
}
