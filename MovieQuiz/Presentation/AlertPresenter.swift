//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 13.06.23.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(_ model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func showAlert(_ model: AlertModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
            
        }
        
        alertController.addAction(action)
        
        viewController?.present(alertController, animated: true)
        
    }
}

/*
 В классе MovieQuizViewController есть метод show(quiz result: QuizResultsViewModel).
 Таким образом ваш контроллер в методе окончания игры должен:
 создавать модель для AlertPresenter,
 передавать её в написанный вами метод этого класса для отображения алерта.
 Не забудьте, что по нажатию на кнопку алерта контроллер должен обновить своё состояние и запустить игру заново.
 Для отображения алерта AlertPresenter должен знать о контроллере, на котором будет отображён алерт.
 Инъектируйте контроллер, на котором нужно отобразить алерт, в AlertPresenter.
 
 let action = UIAlertAction(title: result.buttonText, style: .default) {[weak self] _ in
 guard let self = self else { return }
 self.currentQuestionIndex = 0
 self.correctAnswers = 0
 
 self.questionFactory?.requestNextQuestion()
 
 }
 
 alert.addAction(action)
 self.present(alert, animated: true, completion: nil) */




