//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Видич Анна  on 14.3.23..
//

import XCTest
@testable import MovieQuiz


class MovieQuizUITests: XCTestCase {
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
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertEqual(firstPosterData, secondPosterData)
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testGameFinish() {
        for _ in 1...10 {
            let randomButtonIndex = Int.random(in: 0...1)
            let button = randomButtonIndex == 0 ? app.buttons["Yes"] : app.buttons["No"]
            button.tap()
        }
        
        sleep(2)
        
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            let randomButtonIndex = Int.random(in: 0...1)
            let button = randomButtonIndex == 0 ? app.buttons["Yes"] : app.buttons["No"]
            button.tap()
        }
        sleep(2)
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}
