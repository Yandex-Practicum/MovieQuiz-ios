//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Марина Писарева on 19.12.2022.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: () -> Void
}
