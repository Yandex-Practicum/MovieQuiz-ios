//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 26.09.2023.
//

import Foundation
protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get set}
    func show(model: AlertModel)
}
