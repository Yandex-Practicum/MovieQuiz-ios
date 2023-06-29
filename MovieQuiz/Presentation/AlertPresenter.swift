import UIKit
import Foundation

protocol AlertPresenter {
    func show(alertModel: AlertModel)
}

final class AlertPresenterImpl: AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

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
