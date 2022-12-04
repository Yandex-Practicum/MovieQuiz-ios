//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Редька on 27.11.2022.
//

import Foundation
protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get set }
    func showResult(alertModel: AlertModel)
}
