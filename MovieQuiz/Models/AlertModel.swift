//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Marina on 17.10.2022.
//

import Foundation
internal struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void //замыкание без параметров для действия по кнопке completion
    
}
