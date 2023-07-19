//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 11.07.2023.
//

import UIKit

struct AlertModel{
    var title: String
    var message: String
    var buttonText: String
    var completion: (UIAlertAction) -> Void
}
