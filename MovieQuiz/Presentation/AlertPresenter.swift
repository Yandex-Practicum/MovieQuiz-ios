//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Malik Timurkaev on 19.11.2023.
//

import UIKit


class AlertPresenter {
    public weak var controller: MovieQuizViewController?
    
    func show2(quiz result: AlertModel) {

        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            

            guard let self = self else {return}
            self.controller?.currentQuestionIndex = 0
            self.controller?.correctAnswers = 0
            
            self.controller?.questionFactory.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    
}




//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)


//        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak controller] _ in



//var currentQuestionIndex: Int = 1 {
//        didSet {
//            if currentQuestionIndex == 0 {
//                controller?.currentQuestionIndex = 0
//            }
//        }
//    }
//    var correctAnswers: Int = 1 {
//        didSet {
//            if correctAnswers == 0 {
//                controller?.correctAnswers = 0
//            }
//        }
//    }
