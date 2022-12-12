//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Mikhail Kolokolnikov on 12.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
