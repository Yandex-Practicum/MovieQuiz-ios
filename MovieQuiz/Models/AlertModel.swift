//
//  Alert.swift
//  MovieQuiz
//
//  Created by Alexey Tsidilin on 26.10.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}

