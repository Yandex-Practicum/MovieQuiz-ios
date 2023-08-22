//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Ivan on 22.08.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func hideLoadingIndicator() {

    }
    func showLoadingIndicator() {

    }
    func showNetworkError(message: String) {

    }
    func show(quiz step: QuizStepViewModel) {

    }
    func enabledButtons(isEnabled: Bool) {

    }
    func highlightImageBorder(isCorrectAnswer: Bool){

    }

    var alertPresenter: MovieQuiz.AlertPresenterProtocol?
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
