import XCTest

@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func highlightImageBorder(isCorrectAnswer isCorrect: Bool) {}
    func showLoadingIndicator() {}
    func showResult(present: UIAlertController) {}
    func hideLoadingIndicator() {}
    func setInteractionEnabled(_ val: Bool) {}
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
