//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ruslan Batalov on 11.12.2022.
//



import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctanswerQuestion: Int = 0
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactory?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
}
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func showNextQuestionOrResults(){
        
        if self.isLastQuestion(){
            self.viewController?.statisticService?.store(correct: correctanswerQuestion, total: questionsAmount)
            
            
            let text = "Ваш результат: \(correctanswerQuestion)/\(questionsAmount) \n Количество сыграных квизов: \(self.viewController?.statisticService?.gamesCount ?? 0) \n      Рекорд: \(self.viewController?.statisticService?.bestGame.correct ?? 0)/\(questionsAmount) (\(self.viewController?.statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString )) \n Средняя точность: \(String(format: "%.2f", 100*(self.viewController?.statisticService?.totalAccuracy ?? 0)/Double(self.viewController?.statisticService?.gamesCount ?? 0)))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            self.correctanswerQuestion = 0
            self.viewController?.show(quiz: viewModel)
        }
                    else {
                        self.switchToNextQuestion()
                        self.questionFactory?.requestNextQuestion()
        }
    }
    
    
}


