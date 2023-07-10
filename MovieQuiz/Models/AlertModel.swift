//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Андрей Чупрыненко on 10.07.2023.
//

import Foundation

public struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
