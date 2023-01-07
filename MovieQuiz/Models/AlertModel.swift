//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Егор Свистушкин on 25.12.2022.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: (() -> Void)
}
