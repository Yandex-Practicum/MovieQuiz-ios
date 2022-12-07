import UIKit

class AlertPresenter {
    
    private let model: AlertModel
    weak var viewController: UIViewController?
    
    init(modelShowAlert model: AlertModel){ 
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
