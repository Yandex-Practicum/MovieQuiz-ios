import UIKit

final class AlertPresenter: ShowAlertProtocol { weak var alertDelegate: UIViewController?
    
    init(alertDelegate: UIViewController) {
        self.alertDelegate = alertDelegate
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)
        
        
        alert.addAction(action)
        alertDelegate?.present(alert, animated: true, completion: nil)
    }
    
    
}
