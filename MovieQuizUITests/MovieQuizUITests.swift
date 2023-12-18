//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Михаил  on 17.12.2023.
//

import XCTest

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

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() throws {
        sleep(3)
        let firstPorster = app.images["Poster"]
        let firstPosterData = firstPorster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData,secondPosterData)
    }
    func testNoButton() throws {
        sleep(3)
        let firstPorster = app.images["Poster"]
        let firstPosterData = firstPorster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData,secondPosterData)
    }
    func testIndex() throws {
        sleep(3)
        app.buttons["Yes"].tap()
        sleep(3)
        let index = app.staticTexts["Index"]
        XCTAssertEqual(index.label, "2/10")
    }
    
    func testAlert() throws {
        sleep(3)
        for _ in 1...10{
            app.buttons["Yes"].tap()
            sleep(3)
        }
        let alert = app.alerts["AlertResult"]
//        XCTAssertTrue(alert.waitForExistence(timeout: 5))
//           XCTAssertTrue(alert.staticTexts.element.label.contains("Игра окончена!"))
//           XCTAssertTrue(alert.buttons["Сыграть еще раз"].exists)
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Игра окончена!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
}
