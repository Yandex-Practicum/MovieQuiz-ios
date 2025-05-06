//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Тимур Мурадов on 03.04.2023.
//

import Foundation

struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
