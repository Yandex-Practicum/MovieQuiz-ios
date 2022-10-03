//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by macOS on 30.09.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: ((UIAlertAction) -> Void)?
}
