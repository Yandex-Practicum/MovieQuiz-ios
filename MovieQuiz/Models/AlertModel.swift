//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Андрей Манкевич on 17.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)?    //let buttonText: () -> Void
}
