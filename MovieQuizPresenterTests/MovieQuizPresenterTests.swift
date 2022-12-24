//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Григорий Сухотин on 15.12.2022.
//

import XCTest
@testable import MovieQuiz

class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func hideLoadingIndicator() {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func resetAnwserResult() {
        
    }
    
    func highlightBorders(isCorrect: Bool) {
        
    }
    
    func enableAnswerButtons() {
        
    }
    
    func disableAnswerButtons() {
        
    }
    
    
}

class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(controller: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}
