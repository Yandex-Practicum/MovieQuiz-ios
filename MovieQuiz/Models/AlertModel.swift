//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Игорь Полунин on 08.02.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion:() -> ()
}
