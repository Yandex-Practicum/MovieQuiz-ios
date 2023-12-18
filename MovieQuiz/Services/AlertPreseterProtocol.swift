//
//  AlertPreseterProtocol.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 11.12.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    func showAlert(quiz result: AlertModel)
    var delegate: UIViewController? {get set}
}
