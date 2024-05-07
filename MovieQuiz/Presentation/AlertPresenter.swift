//
//  AlertPresent.swift
//  MovieQuiz
//
//  Created by Daud Tsechoev on 07.05.2024.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    
    func showAlert(model result : AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {
    
   weak var delegate : UIViewController?
    
   init(delegate: UIViewController) {
          self.delegate = delegate
      }
   
   func showAlert(model result : AlertModel){
       let alert = UIAlertController(
           title: result.title,
           message: result.message,
           preferredStyle: .alert)

       let action = UIAlertAction(title: result.buttonText, style: .default) {  _ in

           result.completion()
       }

       alert.addAction(action)

       delegate?.present(alert, animated: true, completion: nil)
   }

}

