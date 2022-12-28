//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Kosov on 27.12.2022.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(result: AlertModel)
    var delegate: UIViewController? { get set }
}

final class AlertPresenter: AlertPresenterProtocol {

    var delegate: UIViewController?

    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.message, // текст во всплывающем окне
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }

        alert.addAction(action)
        showAlert(alert)
    }


    func showAlert(_ alert: UIAlertController) {
        delegate?.present(alert, animated: true)
    }

}

