//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ina on 20/03/2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttontext: String
    var completion: ((UIAlertAction) -> Void)?
}

