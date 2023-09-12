//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by  Игорь Килеев on 02.09.2023.
//

import Foundation


struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
    
}
