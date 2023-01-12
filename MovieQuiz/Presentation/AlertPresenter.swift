//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksey Kosov on 27.12.2022.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(model: AlertModel)
    var delegate: UIViewController? { get set }
}

 struct AlertPresenter: AlertPresenterProtocol {

    weak var delegate: UIViewController?

    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title, // заголовок всплывающего окна
                                      message: model.message, // текст во всплывающем окне
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }

        alert.addAction(action)
        showAlert(alert)
    }


    func showAlert(_ alert: UIAlertController) {
        delegate?.present(alert, animated: true)
    }

}

