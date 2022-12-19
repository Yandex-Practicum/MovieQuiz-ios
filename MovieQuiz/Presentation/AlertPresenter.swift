import UIKit

class AlertPresenter: AlertProtocol {
    
    private weak var delegate: AlertDelegate?
    
    func configure(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in
            model.completion?()
        })
        alert.addAction(action)
        delegate?.show(alert: alert)
    }
    
    init(delegate: AlertDelegate) {
        self.delegate = delegate
    }
}


