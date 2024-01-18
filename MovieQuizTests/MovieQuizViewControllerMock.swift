//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Sergey Ivanov on 17.01.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setAnswerButtonsEnabled(_ enabled: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showQuestionAnswerResult(isCorrect: Bool) {
        
    }
    
    func showQuizResults(model: MovieQuiz.AlertModel?) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func showQuestion(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        //let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1 / 10")
    }
}
