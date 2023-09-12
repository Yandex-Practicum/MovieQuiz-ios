//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by LERÄ on 12.09.23.
//

import Foundation
import UIKit

struct AlertModel {
    
    let title : String
    let message: String
    let textButton: String
    let completion: () -> Void
    
    init(title: String, message: String, textButton: String, completion: @escaping () -> Void) {
        self.title = title
        self.message = message
        self.textButton = textButton
        self.completion = completion
    }
}
