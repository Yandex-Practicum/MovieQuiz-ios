//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 09.12.2023.
//

import UIKit

struct AlertModel{
    var title: String
    var message: String
    var buttontext: String
    var buttonAction: (() -> Void)
}
