import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    func testConvertModels() {
        let presenter = MovieQuizPresenter()
        let imageData = UIImage(systemName: "checkmark")!.pngData()!
        let data = QuizQuestion(image: imageData, text: "Проверка", correctAnswer: true)
        let result = presenter.convert(model: data)
        XCTAssertEqual(result.image.pngData(), UIImage(data: imageData)?.pngData())
        XCTAssertEqual(result.question, data.text)
       XCTAssertEqual(result.questionNumber, "1/10")

        
        
    }
}
