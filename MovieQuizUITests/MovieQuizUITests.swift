import XCTest

class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        sleep(5)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let yesButton = app.buttons["Yes"]
        yesButton.tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        sleep(5)
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
        sleep(5)
        
    }
    
    func testNoButton() {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let noButton = app.buttons["No"]
        noButton.tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        sleep(5)
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
        sleep(5)
    }
    
    func testGameStop() {
        sleep(5)
        let button = app.buttons["Yes"]
        for _ in 1...10 {
            button.tap()
            sleep(5)
        }
        
        let alert = app.alerts["alert"]
        XCTAssertTrue(app.alerts["alert"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        sleep(5)
    }
    
    func testAlertDisap() {
        sleep(5)
        let button = app.buttons["Yes"]
        for _ in 1...10 {
            button.tap()
            sleep(5)
        }
        
        sleep(5)
        let alert = app.alerts["alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(5)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(app.alerts["alert"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
       
        sleep(5)
    }
}
