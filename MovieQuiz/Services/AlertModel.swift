//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Леонид Турко on 09.01.2023.
//

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

