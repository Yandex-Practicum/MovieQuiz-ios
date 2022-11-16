//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Илья Тимченко on 16.11.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        
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

final class MovieQuizTests: XCTestCase {
    func testConvert() throws {
        let mockController = MovieQuizViewControllerProtocolMock()
        let presenter = MovieQuizPresenter(viewController: mockController)
        let data = Data()
        let question = QuizQuestion(image: data, text: "Текст вопроса", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        XCTAssertTrue(viewModel.question == "Текст вопроса")
        XCTAssertNotNil(viewModel.image)
        XCTAssertTrue(viewModel.questionNumber == "1/10")
    }
}
