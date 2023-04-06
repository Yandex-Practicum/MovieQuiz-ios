import UIKit

class AlertPresenter {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Init's
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Public functions
    
    func showAlert(alertModel: AlertModel) {
        guard let viewController = viewController else { return }
        let alert = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
