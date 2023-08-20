//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 30.07.2023.
//

import Foundation
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    let accessibilityIdentifier: String?
}
