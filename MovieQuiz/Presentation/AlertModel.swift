//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 25.11.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (UIAlertAction) -> ()
}
