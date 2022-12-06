
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
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    func testEndOfRoundAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }

        let alert = app.alerts["Этот раунд окончен!"]
        

        XCTAssertTrue(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    func testEndOfRoundAlertButton() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        sleep(1)
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }
}

