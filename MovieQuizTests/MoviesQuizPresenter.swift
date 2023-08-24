//
//  MoviesQuizPresenter.swift
//  MovieQuizTests
//
//  Created by TATIANA VILDANOVA on 23.08.2023.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quizStep model: MovieQuiz.QuizStepViewModel) { }
    func show(alert model: MovieQuiz.AlertModel) { }
    func toggleButtons(to state: Bool) { }
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    func showLoadingIndicator(is state: Bool) { }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(question: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
