//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ольга Чушева on 21.03.2023.
//

import Foundation
import UIKit

protocol AlertProtocol: AnyObject {
    func show(alertModel: AlertModel)
}

final class AlertPresenter {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}
    
    extension AlertPresenter: AlertProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            
            alertModel.completion()            
        }
            
        alert.addAction(action)
        
            
        viewController?.present(alert, animated: true)
    }
    }
    



// self.currentQuestionIndex = 0
     
     // скидываем счетчик правильных ответов
//   self.correctAnswear = 0
     
     // заново показываем первый вопрос
   //  questionFactory?.requestNextQuestion()


