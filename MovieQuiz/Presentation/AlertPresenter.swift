import UIKit

final class AlertPresenter {
    
    func present(view controller: UIViewController, alert model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
