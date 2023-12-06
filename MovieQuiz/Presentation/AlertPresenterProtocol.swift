import UIKit

protocol AlertPresenterProtocol {
    func showAlert(quiz result: AlertModel)
    var delegate: UIViewController? {get set}
}
