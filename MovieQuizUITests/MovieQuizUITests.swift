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
       
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["Yes"].tap() // находим кнопку "Да" и нажимаем ее
        sleep(3)

        let secondPoster = app.images["Poster"]  // еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что посты разные
    }

    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation

        app.buttons["No"].tap() // находим кнопку "Нет" и нажимаем ее
        sleep(3)
        
        let secondPoster = app.images["Poster"]  // еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]

        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что посты разные
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
