import UIKit

struct AlertPresenter: AlertProtocol {
   
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    internal func showAlert(quiz result: AlertModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: result.completion)

        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}


