
import XCTest
@testable import MovieQuiz

final class QuestionFactoryMock: QuestionFactoryProtocol {
    var delegate: MovieQuiz.QuestionFactoryDelegate?
    func requestNextQuestion() {}
    func loadData() {}
    func resetData() {}
}
final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    func show(quiz result: QuizResultsViewModel) {}
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
}
final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let questionFactoryMock = QuestionFactoryMock()
        let statisticServiceMock = StatisticServiceMock()
        let sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            questionFactory: questionFactoryMock,
            statisticService: statisticServiceMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
final class StatisticServiceMock: StatisticService {
    func store(correct count: Int, total amount: Int) {}
    var totalAccuracy: Double = 0.0
    var gamesCount: Int = 0
    var bestGame: MovieQuiz.GameRecord
    var totalCorrectAnswers: Int = 0
    var totalQuestionsPlayed: Int = 0
    init(bestGame: MovieQuiz.GameRecord = MovieQuiz.GameRecord(correct: 0, total: 0, date: Date())) {
        self.bestGame = bestGame
    }
}
