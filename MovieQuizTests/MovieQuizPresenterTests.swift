import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: UIViewController, MovieQuizViewControllerProtocol {
    func updateImageBorder() { }
    func showErrorEmptyJson(message: String) { }
    func show(quiz step: QuizStepViewModel) { }
    func show(quiz result: QuizResultsViewModel) { }
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showNetworkError(message: String) { }
    func showImageError(message: String) { }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData,
            text: "Question Text",
            correctAnswer: true)
        let viewModel = presenter.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
