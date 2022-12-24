//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title : String
    let message : String
    let buttonText : String
    let completion: ((UIAlertAction) -> Void)
}
