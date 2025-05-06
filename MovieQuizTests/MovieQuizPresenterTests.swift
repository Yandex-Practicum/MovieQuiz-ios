//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Артур  Арсланов on 21.01.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAlert() {
        
    }
    
    func chooseIsEnableButtons(_ enabled: Bool) {
        
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
