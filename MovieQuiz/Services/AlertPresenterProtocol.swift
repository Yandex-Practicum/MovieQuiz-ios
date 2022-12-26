//
//  PresentProtocol.swift
//  MovieQuiz
//
//  Created by   apollo on 03.12.2022.
//

import Foundation

protocol AlertPresentProtocol {
    var delegate: AlertPresenterDelegate {get set}
    func present(alert: AlertModel)
}
