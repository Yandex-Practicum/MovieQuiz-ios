import XCTest

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicity_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testNoButton() throws {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }

    func testShowAlert() throws {
        for _ in 1...10 { // цикл с тапом по кнопке 10 раз
            app.buttons["No"].tap()
            sleep(2)
        }

        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "10/10") // проверяем что счетчик подошел к концу

        let resultAlert = app.alerts["Result_Alert"]
        XCTAssert(app.alerts["Result_Alert"].waitForExistence(timeout: 5)) // здесь мы ожидаем появление алерта
        XCTAssertTrue(resultAlert.label == "Этот раунд окончен!") // проверяем что текст на алерте соответствует
    }

    func testHideAlert() throws {
        for _ in 1...10 { // цикл с тапом по кнопке 10 раз
            app.buttons["No"].tap()
            sleep(2)
        }

        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "10/10") // проверяем что счетчик подошел к концу

        let resultAlert = app.alerts["Result_Alert"]
        XCTAssert(app.alerts["Result_Alert"].waitForExistence(timeout: 5)) // здесь мы ожидаем появление алерта
        XCTAssertTrue(resultAlert.label == "Этот раунд окончен!") // проверяем что текст на алерте соответствует

        resultAlert.buttons.firstMatch.tap() // ищем кнопку в алерте
        sleep(2) // ждем
        XCTAssertTrue(indexLabel.label == "1/10") // проверяем что индекс после нажатия на кнопку сбросился
    }
}
