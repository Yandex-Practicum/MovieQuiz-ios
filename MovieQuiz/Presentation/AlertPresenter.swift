import UIKit

class AlertPresenter {
    var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion
        )
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
