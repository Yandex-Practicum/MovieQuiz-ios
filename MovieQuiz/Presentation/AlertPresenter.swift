//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vladimir Vinageras on 14.12.2023.
//

import Foundation
import UIKit



class AlertPresenter: AlertPresenterProtocol{
  
    weak var delegate : AlertPresenterDelegate?
    
    private var alertModel : AlertModel?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func setDelegate(_ delegate: AlertPresenterDelegate) {
            self.delegate = delegate
        }
    
   private func setAlertModel(alertModel : AlertModel){
        self.alertModel?.text = alertModel.text
        self.alertModel?.title = alertModel.title
        self.alertModel?.buttonText = alertModel.buttonText
       self.alertModel?.completion = {
         //  self.delegate?.didTappedAlertButton()
       }
    }

    func showAlert(alertModel : AlertModel) {
        
      // aqui tiener que ir la funcion del delegate
      //  setAlertModel(alertModel: alertModel)
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.text,
            preferredStyle: .alert)
        
        let completion = alertModel.completion
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default){ [weak self] _ in
            guard let self = self else { return  }
            self.delegate?.didTappedAlertButton()
        }
        alert.addAction(action)
         
    delegate?.willShowAlert(alert: alert)
    }
}

