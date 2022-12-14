//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Mikhail Kolokolnikov on 14.12.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion : ((UIAlertAction) -> Void)
}
