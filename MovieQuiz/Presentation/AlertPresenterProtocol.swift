//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Даниил Романов on 04.03.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    var viewController: UIViewController? { get set }
    func show(alertModel: AlertModel)
}
