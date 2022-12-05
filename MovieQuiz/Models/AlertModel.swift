//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Сироткин on 30.11.2022.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
