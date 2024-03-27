//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Yerman Ibragimuly on 28.02.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void?
}
