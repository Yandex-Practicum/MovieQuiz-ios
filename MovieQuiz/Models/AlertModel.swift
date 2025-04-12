//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 09.02.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)?
}
