//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by DANCECOMMANDER on 19.05.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // Это специальная настройка для тестов: если один не прошел,
        // то следующие тесты запускаться не будут.
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

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку "да" и нажимаем
        
        let secondPoster = app.images["Poster"] // еще раз находим постер
        
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }

}


