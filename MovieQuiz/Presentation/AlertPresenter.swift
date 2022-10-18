import Foundation
import UIKit

struct AlertPresenter {
    weak var viewController: UIViewController?
    
    func showAlert (alertModel:AlertModel) {
        let alert = UIAlertController(
            title: alertModel.alertTitle,
            message: alertModel.alertMessage,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.alertButtonText, style: .default, handler:alertModel.completion)
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true,completion: nil)
        
    }
}

