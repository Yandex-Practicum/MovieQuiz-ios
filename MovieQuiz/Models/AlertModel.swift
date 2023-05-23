//
//  AllertModel.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 19.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
