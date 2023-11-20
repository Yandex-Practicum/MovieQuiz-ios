//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 19.11.2023.
//

import UIKit

//Структруа вызова уведомления
struct AlertModel {
    
    var title: String
    
    var message: String
    
    var buttonText: String
    
    var completion: (() -> UIAlertAction)?
    
}
