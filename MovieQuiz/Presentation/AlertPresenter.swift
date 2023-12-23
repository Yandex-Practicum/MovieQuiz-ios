import UIKit


protocol AlertPresenter{
    func show (alertModel: AlertModel)
}

final class AlertPresenterImpl{
    weak var viewController : UIViewController?
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
}

extension AlertPresenterImpl: AlertPresenter{
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
       alert.view.accessibilityIdentifier = alertModel.accessibilityIdentifier
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self]_ in
            guard self != nil else { return }
            
            alertModel.buttonAction()
        }
        
        
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
