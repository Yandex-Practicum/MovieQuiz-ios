import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var alertVC: UIViewController?
    weak var delegate: AlertPresenterDelegate?
    
    init(alertVC: UIViewController?, delegate: AlertPresenterDelegate?) {
        self.alertVC = alertVC
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { [self] _  in
                delegate?.didShowAlert()
            }
        alert.addAction(action)
        alertVC?.present(alert, animated: true, completion: model.completion)
    }
}
