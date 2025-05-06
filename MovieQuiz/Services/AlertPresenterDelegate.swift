import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(alertModel: AlertModel?)
}
