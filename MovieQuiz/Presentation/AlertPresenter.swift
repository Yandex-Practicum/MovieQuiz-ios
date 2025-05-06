import Foundation
import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: alertModel.buttonTexts,
            style: .default) { _ in
                alertModel.completions()
            }
        alert.addAction(action)
        delegate?.showAlert(alert: alert)//changed
    }
}
