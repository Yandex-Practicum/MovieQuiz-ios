//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 04.03.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> ();
}
