import UIKit

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.message,
                                      preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in 
            result.completion()
        }
        
        alert.addAction(alertAction)
        
        delegate?.didReceiveAlert(alert: alert)
    }
}
