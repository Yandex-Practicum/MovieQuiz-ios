//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Artem Adiev on 10.01.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошел,
        // то следующие запускаться не будут; зачем ждать?
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        
        let firstPoster = app.images["Poster"] // находим первый постер
        app.buttons["Yes"].tap() // находим кнопку "Да" и нажимаем ее
        let secondPoster = app.images["Poster"] // находим второй постер
        let indexLabel = app.staticTexts["Index"] // находим лейбл с индексом вопроса
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10") // проверяем, что индекс обновился
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
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
            sleep(1)
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(app.alerts["Game results"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        
        for _ in 1...10 {
            sleep(1)
            app.buttons["No"].tap()
        }
        
        sleep(3)
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Game results"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
