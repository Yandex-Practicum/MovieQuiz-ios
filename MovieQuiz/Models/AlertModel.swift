//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Vladimir Vinageras on 14.12.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var text:  String
    var buttonText: String
    var completion : () -> Void
}
