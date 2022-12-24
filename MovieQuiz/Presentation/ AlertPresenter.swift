//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

class AlertPresenter {
    weak var viewController : UIViewController?
    init(viewController: UIViewController?)
    {
        self.viewController = viewController
    }
    func show(result : AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
