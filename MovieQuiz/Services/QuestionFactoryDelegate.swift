//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Mir on 23.03.2023.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadImage()
}
