import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController)
}
