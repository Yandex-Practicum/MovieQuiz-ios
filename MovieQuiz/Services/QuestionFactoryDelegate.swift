//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Yuriy Varvenskiy on 16.08.2023.
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
