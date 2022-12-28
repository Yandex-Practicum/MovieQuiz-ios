//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 09.10.2022.
//

import Foundation

struct AlertModel{
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
