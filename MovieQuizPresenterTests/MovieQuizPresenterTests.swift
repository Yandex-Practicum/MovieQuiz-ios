//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Ruslan Batalov on 11.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quiz rezult: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func hightLightImageBorder(isCorrectAnswer: Bool) {
        
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
