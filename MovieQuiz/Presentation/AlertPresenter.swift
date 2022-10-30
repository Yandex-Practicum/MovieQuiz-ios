import UIKit

class AlertPresenter: AlertPresenterDelegate {
    var startOverDelegate: AlertPresentProtocol?
    init(startOverDelegate: AlertPresentProtocol) {
        self.startOverDelegate = startOverDelegate
    }
    func showAlert (alertModel: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.masseg,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self]_ in
            self?.startOverDelegate?.startOver()
        }
        alert.addAction(action)
        return alert
    }
}



