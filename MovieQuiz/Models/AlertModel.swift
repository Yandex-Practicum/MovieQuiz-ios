//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий on 10.02.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (UIAlertAction) -> Void
}
