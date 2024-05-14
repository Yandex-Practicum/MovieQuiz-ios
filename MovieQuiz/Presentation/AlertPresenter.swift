import UIKit

final class AlertPresenter {
    weak var viewController: MovieQuizViewController?

    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }

    func show(alert: AlertModel) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            alert.completion?()
        }
        alertController.addAction(alertAction)
        viewController?.present(alertController, animated: false, completion: nil)
    }
}
