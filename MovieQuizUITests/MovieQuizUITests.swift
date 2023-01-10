//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Алексей on 06.01.2023.
//

import XCTest
@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
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
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testNoButton() throws {
        
        let firstPoster = app.images["Poster"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testAlertAppeared() throws {
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
            
        sleep(5)
        
        let alert = app.alerts["Game Results"]
            
        XCTAssertTrue(app.alerts["Game Results"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз!")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        sleep(5)
        
        let alert = app.alerts["Game Results"]
        alert.buttons.firstMatch.tap()
        
        sleep(5)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Game Results"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
