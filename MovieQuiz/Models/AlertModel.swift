//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 18.12.2023.
//

import Foundation

struct AlertModel{
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
