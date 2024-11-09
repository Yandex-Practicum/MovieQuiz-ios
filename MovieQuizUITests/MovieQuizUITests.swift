

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
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
    
    @MainActor
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testIndex() {
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
    }
    
    func testFinalAlert() {
        for _ in 1...10 {
            sleep(3)
            app.buttons["No"].tap()
        }
        sleep(3)
        let alert = app.alerts["finalOrErrorAlert"]
        let alertButton = alert.buttons.firstMatch
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alertButton.label == "Сыграть ещё раз")
        alertButton.tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
