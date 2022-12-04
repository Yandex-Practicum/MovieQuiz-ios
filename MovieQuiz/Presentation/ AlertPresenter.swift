//
//   AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexander Farizanov on 04.12.2022.
//

import Foundation
import UIKit

struct AlertPresenter {
    
    var viewController : UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
     func show(quiz result : AlertModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: result.completion)
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
