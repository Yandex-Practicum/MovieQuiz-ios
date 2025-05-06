//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexey Ponomarev on 19.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
