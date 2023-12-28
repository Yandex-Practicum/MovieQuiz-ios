//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ilya Shirokov on 27.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion:() -> ()
}
