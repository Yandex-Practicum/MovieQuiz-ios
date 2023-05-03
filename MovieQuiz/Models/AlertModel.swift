//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by DANCECOMMANDER on 18.04.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> ())?
}
