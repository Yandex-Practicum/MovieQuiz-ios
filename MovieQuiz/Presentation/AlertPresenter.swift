import UIKit

class AlertPresenter: ModelAlertProtocol {
    func showAlert (model: AlertModel, view: UIViewController) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: model.buttonText,
                                        style: .default) { _ in model.comletion() }
        alert.addAction(actionAlert)
        view.present(alert, animated: true)
    }
    weak var view: UIViewController?
    init(view: UIViewController? = nil) {
        self.view = view
    }
}
