//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by admin on 02.01.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText : String
    var ButtonAction: () -> Void
}
