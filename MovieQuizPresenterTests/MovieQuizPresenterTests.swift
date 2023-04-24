//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Ina on 23/04/2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var activityIndicator: UIActivityIndicatorView!
    var yesButton: UIButton!
    var noButton: UIButton!
    var imageView: UIImageView!
    
    func freezeButton() {
    }
    
    func show(quiz step: QuizStepViewModel) {
    }
    
    func show(quiz result: QuizResultsViewModel){
    }
    
    func highLightImageBorder(isCorrectAnswer: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
    
    func showNetworkError(message: String) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterCoventModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question,"Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
 
