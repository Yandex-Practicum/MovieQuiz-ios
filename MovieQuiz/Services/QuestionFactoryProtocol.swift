//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Flymetric on 22.02.2026.
//



protocol QuestionFactoryProtocol: AnyObject {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
  //  func questionCount() -> Int
}
