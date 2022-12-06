//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

class AlertPresenter {
    
    private var questionFactory: QuestionFactoryProtocol? = nil
    weak var alertController : UIViewController?
    init(alertController: UIViewController?)
    {
        self.alertController = alertController
    }
    
    func show(result : AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default)
      //      guard let completion? = result.completion else { return }
       //                    completion()
     
        alert.addAction(action)
        
        alertController?.present(alert, animated: true, completion: nil)
        UIView.animate(withDuration: 0, delay: 1.5, options: [], animations: { })
            //questionFactory?.requestNextQuestion()
        
    }
}
