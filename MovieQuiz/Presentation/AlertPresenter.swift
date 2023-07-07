import UIKit
import Foundation

// Протокол для презентера алертов
protocol AlertPresenter {
    func show(alertModel: AlertModel)
}

// Реализация презентера алертов
final class AlertPresenterImpl: AlertPresenter {
    private weak var viewController: UIViewController?

    // Инициализатор презентера алертов
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    // Метод для отображения алерта
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }

        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

