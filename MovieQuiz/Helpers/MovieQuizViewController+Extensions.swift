import Foundation
import UIKit

extension MovieQuizViewController: AlertPresenterDelegate{
    func didShowAlert(alertModel: AlertModel?) {
        let alert = UIAlertController(
            title: alertModel?.title,
            message: alertModel?.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
