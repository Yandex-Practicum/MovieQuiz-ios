//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ярослав Калмыков on 17.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (() -> Void)?
}
