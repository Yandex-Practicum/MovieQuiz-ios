
import UIKit

struct AlertPresenter: AlertPresenterProtocol {
  
  weak var delegate: AlertPresenterDelegate?
  
  func showResult(quizResult: AlertModel) {   
    let alert = UIAlertController(
      title: quizResult.title,
      message: quizResult.message,
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: quizResult.buttonText, style: .default, handler: quizResult.completion)
    alert.addAction(action)

    delegate?.presentQuizResults(alert)
  }
  
}
