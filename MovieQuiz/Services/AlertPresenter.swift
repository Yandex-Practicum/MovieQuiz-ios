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
    
    func alertSignal() {
        print("We passed through AlertPresenter class")
        guard let delegate = delegate else { return }
        delegate.showResults()
    }
}
