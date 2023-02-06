//
//  MovieQuizControllerTests.swift
//  MovieQuizControllerTests
//
//  Created by User on 06.02.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    var activityIndicator: UIActivityIndicatorView!
    
    func highLightImageBorder(isCorrect: Bool) {
        
    }
    
    func setupActivityIndicator() {
        
    }
    
    func showAndGameAlert() {
        
    }
    
    func blockingButton() {
        
    }
    
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
}

final class MovieQuizControllerTests: XCTestCase {

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
