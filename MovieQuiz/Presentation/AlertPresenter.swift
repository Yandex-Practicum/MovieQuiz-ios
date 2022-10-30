import UIKit

class AlertPresenter: AlertPresenterDelegate {
    weak var startOverDelegate: AlertPresentProtocol?
    init(startOverDelegate: AlertPresentProtocol) {
        self.startOverDelegate = startOverDelegate
    }
    func showAlert (alertModel: AlertModel) -> UIAlertController {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.masseg,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self]_ in
            guard let self = self else { return }
            self.startOverDelegate?.startOver()
        }
        alert.addAction(action)
        return alert
    }
}



