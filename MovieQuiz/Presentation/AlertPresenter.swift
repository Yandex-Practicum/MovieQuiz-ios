//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 09.12.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {

    weak var delegate: UIViewController?
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }

    func showAlert(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttontext, style: .default) {_ in result.completion()}

        alert.addAction(action)

        delegate?.present(alert, animated: true, completion: nil)
    }
}
