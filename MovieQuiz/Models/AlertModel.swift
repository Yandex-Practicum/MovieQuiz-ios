//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by   apollo on 02.12.2022.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
