
//import UIKit
//
//class AlertPresenter: AlertPresenterProtocol {
//
//    weak var delegate: UIViewController?
//
//    init(delegate: UIViewController) {
//        self.delegate = delegate
//    }
//
//    func showQuizResult(model: AlertModel) {
//        let alert = UIAlertController(
//            title: model.title,
//            message: model.message,
//            preferredStyle: .alert)
//        let action = UIAlertAction(
//            title: model.buttonText,
//            style: .default) { _ in
//                model.completion()}
//
//        alert.addAction(action)
//        alert.preferredAction = action
//
//        delegate?.present(alert, animated: true, completion: nil)
//    }
//}

import UIKit

protocol AlertPresenterProtocol {
    func show(result: AlertModel)
    var delegate: UIViewController? { get set }
}

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title,      // заголовок всплывающего окна
                                      message: result.message, // текст
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        showAlert(alert)
    }
    
    func showAlert(_ alert: UIAlertController) {
        delegate?.present(alert, animated: true)
    }
    
}

