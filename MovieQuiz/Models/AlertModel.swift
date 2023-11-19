//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 19.11.2023.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var comletion: (UIAlertAction) -> Void = {_ in }
}
