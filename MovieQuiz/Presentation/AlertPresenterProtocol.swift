//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Popov on 15.01.2024.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    var delegate: AlertPresenterDelegate? {get set}
    func show(alertModel: AlertModel)
}
