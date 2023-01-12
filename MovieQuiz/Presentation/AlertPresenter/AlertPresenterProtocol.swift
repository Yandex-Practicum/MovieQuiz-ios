//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Viktoria Lobanova on 02.12.2022.
//

import UIKit

protocol AlertPresenterProtocol {
    var controller: UIViewController? { get set }
    func show(alert model: AlertModel, identifier: String)
}
