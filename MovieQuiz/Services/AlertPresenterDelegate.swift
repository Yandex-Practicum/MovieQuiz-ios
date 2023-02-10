import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(model: AlertModel)
    func didLoad(_ vc: UIViewController)
}

class AlertPresenterDelegate: AlertPresenterProtocol {
    
    weak private var viewController: UIViewController?
    
    func didLoad(_ vc: UIViewController) {
        self.viewController = vc
    }
    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let actionAlert = UIAlertAction(title: model.buttonText,
                                        style: .default) { _ in model.comletion()
            
            
        }
        alert.addAction(actionAlert)
        showAlert(alert: alert)
    }
    func showAlert(alert: UIAlertController) {
        viewController?.present(alert, animated: true)
    }
}

