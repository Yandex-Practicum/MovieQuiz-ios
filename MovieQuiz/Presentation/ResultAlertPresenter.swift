// swiftlint: disable all

import Foundation
import UIKit

struct ResultAlertPresenter {
    var viewController: UIViewController

    func showResultAlert (result: QuizResultsViewModel, onAction: @escaping () -> Void) {
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, /* текст во всплывающем окне */
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(
            title: "Сыграть ещё раз",
            style: .default, handler: { _ in
                onAction()
            }
        )

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        viewController.present(alert, animated: true, completion: nil)
    }
}
