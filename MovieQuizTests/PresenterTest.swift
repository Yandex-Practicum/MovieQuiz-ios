//
//  PresenterTest.swift
//  MovieQuizTests
//
//  Created by Fedor on 25.12.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizControllerMock: MovieQuizControllerProtocol {
    var imageView: UIImageView!
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    
    }
    
    func showLoadingIndictor() {
        
    }
    
    func hideLoadingIndicator() {

    }
    
    func isButtonsBlocked(state: Bool) {

    }
}

final class MovieQuizPresenterTest: XCTestCase {
    
    func testPeresenterCnvertModel () throws {
        
        let viewControllerMock = MovieQuizControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Test", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Test")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
