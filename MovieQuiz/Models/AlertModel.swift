//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 10/18/22.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
