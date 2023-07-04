//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Владимир Клевцов on 13.6.23..
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
    func testYesButton() {
        sleep(1)
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
       
        XCTAssertEqual(indexLabel.label, "2/10")
        //XCTAssertFalse(firstPosterData == secondPosterData)
     XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testNoButton() {
        sleep(1)
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(1)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
       
        XCTAssertEqual(indexLabel.label, "2/10")
        //XCTAssertFalse(firstPosterData == secondPosterData)
     XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testAlert() {
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        sleep(1)
        let alert = app.alerts["Alert"]
        
        XCTAssertNotNil(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
        
        alert.buttons.firstMatch.tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
