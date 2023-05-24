//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Владимир Клевцов on 17.5.23..
//

import Foundation
struct AlertModel {
    let title: String
    let messege: String
    let buttonText: String
    let comletion: (() -> Void)
}
