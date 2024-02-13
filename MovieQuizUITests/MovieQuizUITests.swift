//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Илья Дышлюк on 28.01.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
        // swiftlint:disable:next implicitly_unwrapped_optional
        var app: XCUIApplication!
        
        override func setUpWithError() throws {
            try super.setUpWithError()
            
            app = XCUIApplication()
            app.launch()
            
            // это специальная настройка для тестов: если один тест не прошёл,
            // то следующие тесты запускаться не будут; и правда, зачем ждать?
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
    }
    
    func testNoButton () {
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
}
