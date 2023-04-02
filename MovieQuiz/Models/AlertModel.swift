//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Mir on 26.03.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
