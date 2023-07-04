//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 17.5.23..
//

import Foundation
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let comletion: (() -> Void)
}
