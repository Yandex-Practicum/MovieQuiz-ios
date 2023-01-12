import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func show(model: AlertModel)
    var delegate: UIViewController? {get set}
}

