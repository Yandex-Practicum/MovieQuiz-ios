//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Роман Бойко on 11/15/22.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
    }
    
    func hideImageBoarder () {
        
    }
    
    func toggleIsEnablebButtons() {
        
    }
    
}


final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterController () throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut  = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}
