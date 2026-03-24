//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Flymetric on 22.02.2026.
//

// если делать как в учебнике то свифт требует
// protocol QuestionFactoryDelegate: AnyObject {
protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
