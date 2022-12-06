import UIKit

class AlertPresenter {

    weak var viewController: UIViewController?
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
}

extension AlertPresenter: AlertPresenterProtocol {
    
    func displayAlert(_ alert: AlertModel) {
        let ac = UIAlertController(title: alert.title,
                                   message: alert.message,
                                   preferredStyle: .alert)
        let action = UIAlertAction(title: alert.buttonText,
                                   style: .default) { _ in
            alert.completion()
        }
        ac.addAction(action)
        viewController?.present(ac, animated: true)
    }
}
