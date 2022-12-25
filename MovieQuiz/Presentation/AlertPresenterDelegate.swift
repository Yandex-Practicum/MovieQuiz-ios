import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didReceiveAlert(alert: UIAlertController)
}
