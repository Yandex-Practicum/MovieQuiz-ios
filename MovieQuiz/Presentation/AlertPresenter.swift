import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var movieQuizViewController: UIViewController?
    
    init(movieQuizViewController: UIViewController?) {
        self.movieQuizViewController = movieQuizViewController
    }
    
    func displayAlert(_ alert: AlertModel) {
        let ac = UIAlertController(title: alert.title,
                                      message: alert.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alert.buttonText,
                                   style: .default) { _ in
            alert.completion()
        }
        
        ac.addAction(action)
        movieQuizViewController?.present(ac, animated: false)
    }
}
