//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 04.01.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: (() -> Void)
}
