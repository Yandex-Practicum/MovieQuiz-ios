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
        print(alertModel.title)
        print(alertModel.message)
        print(alertModel.buttonText)
        guard let delegate = delegate else { return }
        delegate.showResults(title: alertModel.title, message: alertModel.message, buttonText: alertModel.buttonText)
    }
}
