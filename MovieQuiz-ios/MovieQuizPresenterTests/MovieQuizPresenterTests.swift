//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 17.01.2023.
//

import Foundation
import XCTest

@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func showAlert(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrect: Bool){
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    func enableButtons() {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
