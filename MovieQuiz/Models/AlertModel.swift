//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Artem Adiev on 07.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
