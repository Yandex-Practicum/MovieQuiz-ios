//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Баир Шаралдаев on 04.02.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
