import XCTest

@testable import MovieQuiz

final class UITests: XCTestCase {
    var app: XCUIApplication! //Эта переменная символизирует приложение, которое мы тестируем

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        // это специальная настройка для тестов: если один тест не прошёл, то следующие тесты запускаться не будут
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app = nil
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        let yesButton = app.buttons["Yes"]
        yesButton.tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        let noButton = app.buttons["No"]
        noButton.tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testResult() {
        let button = app.buttons["Yes"] //кнопка "Да"
        for _ in 1...10 {
            button.tap()
            sleep(1)
        }
        let alert = app.alerts["Alert"]
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
        
        alert.buttons.firstMatch.tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
