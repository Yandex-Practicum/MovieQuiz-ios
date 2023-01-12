//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Viktoria Lobanova on 10.01.2023.
//
import Foundation
import XCTest
@testable import MovieQuiz

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут;
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    //    func testExample() throws {
    //        // UI tests must launch the application that they test.
    //        let app = XCUIApplication()
    //        app.launch()
    //
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку "Да" и нажимаем ее
        
        let secondPoster = app.images["Poster"]  // еще раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что посты разные
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["No"].tap() // находим кнопку "Да" и нажимаем ее
        
        let secondPoster = app.images["Poster"]  // еще раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что посты разные
    }
    
    func testGameFinish() {
        sleep(3)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alertFinal = app.alerts["Final game"]
        
        sleep(2)
        
        XCTAssertTrue(app.alerts["Final game"].exists)
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
        XCTAssertFalse(app.alerts["Final game"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
