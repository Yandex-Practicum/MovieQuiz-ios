//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 02.12.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let action: (UIAlertAction) -> Void
}
