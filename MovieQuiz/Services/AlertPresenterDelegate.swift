import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alertModel: AlertModel) -> UIAlertController
}
