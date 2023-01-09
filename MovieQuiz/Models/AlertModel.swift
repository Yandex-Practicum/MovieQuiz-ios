//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 27.11.2022.
//

import UIKit
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)? = nil
}
