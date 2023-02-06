//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Влад on 12.01.2023.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (()-> Void)
}
