//
//  MovieQuizUITests.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 17.01.2023.
//

import Foundation
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
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)

        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }

    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }

    func testGameFinish() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alertFinal = app.alerts["Final game"]

        XCTAssertTrue(alertFinal.exists)
        XCTAssertTrue(alertFinal.label == "Этот раунд окончен!")
        XCTAssertTrue(alertFinal.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alertFinal = app.alerts["Final game"]
        alertFinal.buttons.firstMatch.tap()

        sleep(2)

        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alertFinal.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
