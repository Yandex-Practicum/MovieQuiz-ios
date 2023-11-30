import UIKit

class AlertPresenter {
    
     var view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func show(data: AlertModel) {
        let alert = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert)
        alert.view?.accessibilityIdentifier = "Game"
        
        let action = UIAlertAction(title: data.buttonText, style: .default) { _ in
            data.buttonAction()
        }
        
        alert.addAction(action)
        
        view.present(alert, animated: true, completion: nil)
    }   
}

