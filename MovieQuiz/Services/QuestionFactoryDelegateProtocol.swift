//
//  QuestionFactoryDelegateProtocol.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 18.11.2023.
//

import Foundation

protocol QuestionFactoryDelegatePrototocol: AnyObject {
    
    func didFinishReceiveQuestion (question: QuizQuestion?) -> Void
    
}

