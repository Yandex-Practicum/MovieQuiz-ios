import UIKit

class AlertPresenter: AlertPresenterDelegate {
    
    weak var delegate: AlertPresenterProtocol?
    init(delegate: AlertPresenterProtocol) {
        self.delegate = delegate
    }
    
    internal func showAlert(alertModel: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel.buttonText,
                                   style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.resetGame()
        }
        alert.addAction(action)
        return alert
    }
}
