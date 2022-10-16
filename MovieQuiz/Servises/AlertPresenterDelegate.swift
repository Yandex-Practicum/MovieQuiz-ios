import UIKit
protocol AlertPresenterDelegate {
    func showAlert(alertModel: AlertModel) -> UIAlertController
}
