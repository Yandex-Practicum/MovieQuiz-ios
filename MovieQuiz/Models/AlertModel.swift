//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Sergey Popkov on 20.04.2023.
//

import Foundation
import UIKit


struct AlertModel {
    
    let title: String
    let message: String
    let buttonText: String
    let action: () -> Void
}
