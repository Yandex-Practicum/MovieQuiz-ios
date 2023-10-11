import Foundation
import UIKit

protocol AlertPresenterProtocol  {
    func showAlert(alertModel: AlertModel)
}

extension AlertPresenterProtocol where Self: UIViewController {
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title, // заголовок всплывающего окна
                                      message: alertModel.message, // текст во всплывающем окне
                                      preferredStyle: .alert)

        // создаём для него кнопки с действиями
        let repeatAction = UIAlertAction(title: alertModel.buttonText, style: .default, handler: { _ in
            alertModel.completion()
        })
        
        alert.addAction(repeatAction)
        
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
}
