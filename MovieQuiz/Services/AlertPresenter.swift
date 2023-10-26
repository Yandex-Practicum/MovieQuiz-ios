//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Sergey Telnov on 25/10/2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func alertSignal(alertModel: AlertModel) {
        print("We passed through AlertPresenter class")
        guard let delegate = delegate else { return }
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak delegate] _ in
            guard let delegate = delegate else { return }
            delegate.currentQuestionIndex = 0
            delegate.correctAnswers = 0
        }
        delegate.showResults(alert: alert, action: action)
    }
}
