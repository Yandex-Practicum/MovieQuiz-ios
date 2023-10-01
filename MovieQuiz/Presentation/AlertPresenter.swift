//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл on 30.09.2023.
//

import UIKit

final class AlertPresenter {
    weak var delegate: UIViewController?
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    func showResult(_ result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: result.buttonText,
            style: .default) { _ in
                result.completion()
            }
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true)
    }
}
