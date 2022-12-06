//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Кирилл Брызгунов on 03.12.2022.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
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
        let firstPoster = app.images["Poster"] // находим постер
        
        app.buttons["Yes"].tap() // находим кнопку и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10") // проверка на соответсвие индекса
        XCTAssertFalse(firstPoster == secondPoster) // проверка на отличие постеров
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
    
    
    func testAlert() {
        for _ in 0...9 {
            app.buttons["Yes"].tap()
            sleep(3)
        }

        sleep(3)

        let alert = app.alerts["Game Results"]

        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")

    }
    
    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        sleep(5)
        
        let alert = app.alerts["Game Results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Game results"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    } 
    
//    func testAlertDismiss() {
//        for _ in 1...10 {
//            app.buttons["Yes"].tap()
//            sleep(3)
//        }
//
//        sleep(3)
//
//        let alert = app.alerts["Game results"]
//        alert.buttons.firstMatch.tap()
//
//        sleep(3)
//
//        let poster = app.images["Poster"]
//        let indexLabel = app.staticTexts["Index"]
//
//        XCTAssertTrue(indexLabel.label == "1/10")
//        XCTAssertFalse(alert.exists)
//        XCTAssertTrue(poster.exists)
//
//    }
    
}
