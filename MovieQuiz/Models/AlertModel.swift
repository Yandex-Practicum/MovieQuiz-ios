//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Алексей on 27.11.2022.
//
import UIKit


struct AlertModel {
    
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)
    
}


