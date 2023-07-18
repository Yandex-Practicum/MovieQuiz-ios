//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Антон Павлов on 14.07.2023.
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
        
        let app = XCUIApplication()
        app.launch()
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
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
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinishAlert() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }

        // Проверка алерта "Этот раунд окончен!"
        let gameFinishAlert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(gameFinishAlert.exists)
        XCTAssertTrue(gameFinishAlert.label == "Этот раунд окончен!")
        XCTAssertTrue(gameFinishAlert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        // Тапаем на кнопку "Сыграть ещё раз" в алерте "Этот раунд окончен!"
        let gameFinishAlert = app.alerts["Этот раунд окончен!"]
        gameFinishAlert.buttons.firstMatch.tap()
        
        sleep(2)
        
        // Проверка метки "1/10"
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
