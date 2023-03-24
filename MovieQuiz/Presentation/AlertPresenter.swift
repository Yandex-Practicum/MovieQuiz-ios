import UIKit

class AlertPresenter {
    weak var viewController: UIViewController?
    func showAlert(alertModel: AlertModel) {
        guard let viewController = viewController else { return }
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
