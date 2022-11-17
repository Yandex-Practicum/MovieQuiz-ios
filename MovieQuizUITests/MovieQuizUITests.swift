//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Marina Kolbina on 13/11/2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        // это специальная настройка для тестов: если один тест не прошёл, то следующие тесты запускаться не будут
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()

        app.terminate()
        app = nil
    
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

    }

    func testYesButton() {
        let firstPoster = app.images["Poster"]
        
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]

        XCTAssertFalse(firstPoster == secondPoster)

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
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(1)
        }
        
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(4)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Этот раунд окончен!"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
