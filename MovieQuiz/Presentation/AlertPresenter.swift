//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл Брызгунов on 09.10.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {

    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate?){
        self.delegate = delegate
    }

    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: {  _ in model.completion() })
        alert.addAction(action)
        delegate?.didShowAlert(controller: alert)
    }

}


    

