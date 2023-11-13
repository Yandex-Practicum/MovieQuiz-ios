//
//  QuestionFactoryDelegate.swift
//  MovieQuiz

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with errorMessage: String)
    func didFailToLoadImage()
}
