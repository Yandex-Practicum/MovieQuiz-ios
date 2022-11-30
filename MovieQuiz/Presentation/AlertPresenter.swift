//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Veniamin on 13.11.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol{
    
    weak var controller: UIViewController?
    
    init(controller: UIViewController?) {
        self.controller = controller
    }
    
    func showAlert(result: AlertModel){
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
    
        let action = UIAlertAction(title: "Сыграть еще раз",
                                   style: .default,
                                   handler: {_ in result.completition() })
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil )
    }
    
    func restartGame(){
        controller?.viewDidLoad()
    }
    
}


