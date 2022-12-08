//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by tommy tm on 08.12.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)
}
