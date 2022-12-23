import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak private var alertController: UIViewController?
    init(alertController: UIViewController? = nil) {
        self.alertController = alertController
    }
    
    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: { _ in result.completion()
            })
        
        alert.addAction(action)
        alertController?.present(alert, animated: true, completion: nil)
    }
}
