//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Konstantin Zuykov on 08.11.2022.
//

import Foundation
import UIKit

public struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
