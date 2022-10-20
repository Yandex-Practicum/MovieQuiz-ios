import Foundation
import UIKit

class AlertPresenter {
    
    private let model: AlertModel
    var viewController: UIViewController?
    
    init(modelToShowAlert model: AlertModel){
        self.model = model
    }
    
    
    func showAlert() {
        let alertController = UIAlertController.init(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: model.buttonText,
            style: .cancel,
            handler: { _ in
                self.model.completion()
            }))
        viewController?.present(alertController, animated: true)
    }
}
