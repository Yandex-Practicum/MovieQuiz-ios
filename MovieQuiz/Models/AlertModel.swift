//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Артур Коробейников on 31.01.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)?
}
