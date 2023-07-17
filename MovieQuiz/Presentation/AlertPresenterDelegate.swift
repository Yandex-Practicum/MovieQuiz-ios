//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 11.07.2023.
//

import UIKit

protocol AlertPresenterDelegate: UIViewController {
    func startNewQuiz(_: UIAlertAction)
}
