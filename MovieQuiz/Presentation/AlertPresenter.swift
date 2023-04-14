import UIKit

class AlertPresenter {
    
    weak var alertDelegate: UIViewController?
    
    init(alertDelegate: UIViewController) {
        self.alertDelegate = alertDelegate
    }
    
    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)
        
        alert.addAction(action)
    alertDelegate?.present(alert, animated: true, completion: nil)
    }
}

