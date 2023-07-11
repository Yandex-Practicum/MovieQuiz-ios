//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 11.07.2023.
//

import Foundation

protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? { get }
    func alert(with model: AlertModel)
}
