
import UIKit

struct AlertPresenter: AlertPresenterProtocol {
  
  weak var delegate: AlertPresenterDelegate?
  
  func show(alertModel: AlertModel) {   
    let alert = UIAlertController(
      title: alertModel.title,
      message: alertModel.message,
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
    alert.addAction(action)

    delegate?.presentQuizResults(alert)
  }
  
}
