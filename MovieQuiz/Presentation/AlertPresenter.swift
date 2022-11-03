import Foundation
import UIKit

class AlertPresenter {
    var viewController: MovieQuizViewController
    var alertModel: AlertModel
    
    init(
        viewController: MovieQuizViewController,
        alertModel: AlertModel
    ) {
        self.viewController = viewController
        self.alertModel = alertModel
    }
    
    func show() {
        let myCompletion = { [weak self]  in
            guard let self = self else { return }
            self.viewController.currentQuestionIndex = 0
            self.viewController.correctAnswers = 0
            self.viewController.questionFactory?.requestNextQuestion()
        }
        
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(viewController.correctAnswers) из 10",
            buttonText: "Сыграть ещё раз",
            completion: myCompletion)
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.viewController.currentQuestionIndex = 0
                self.viewController.correctAnswers = 0
                self.viewController.questionFactory?.requestNextQuestion()
            })
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: model.completion)
    }
    
    //    let presenter = AlertPresenter(model: model)
    //    presenter.model.title = "Этот раунд окончен!"
    //    presenter.model.message = "Ваш результат: \(viewController.correctAnswers) из 10"
    //    presenter.model.buttonText = "Сыграть ещё раз"
    //
    //
    //
    //        let viewModel = AlertModel(
    //            title: "Этот раунд окончен!",
    //            message: "Ваш результат: \(viewController.correctAnswers) из 10",
    //            buttonText: "Сыграть ещё раз",
    //            completion: <#T##() -> Void#>)
    //
    //
    
}
