//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Flymetric on 22.02.2026.
//

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var completion: () -> Void
}
