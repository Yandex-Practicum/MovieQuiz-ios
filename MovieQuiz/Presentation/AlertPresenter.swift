import UIKit

class AlertPresenter: AlertPresenterDelegate {
    var delegate: UIViewController?
    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: model.buttonText,
                                        style: .default) { _ in model.comletion()
        }
        alert.addAction(actionAlert)
        showAlert(alert: alert)
    }
    func showAlert(alert: UIAlertController) {
        delegate?.present(alert, animated: true)
    }
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }
}
