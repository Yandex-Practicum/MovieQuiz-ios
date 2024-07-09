//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 26/10/2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
