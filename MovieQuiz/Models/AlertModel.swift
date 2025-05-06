//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Popov on 15.01.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var buttonAction: (()->Void)?
}
