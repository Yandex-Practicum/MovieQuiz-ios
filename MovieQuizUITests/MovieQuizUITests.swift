//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Ivan on 22.08.2023.
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
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
    }
  
    func testYesButton() {
        // находим первоначальный постер
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        // находим кнопку `Да` и нажимаем её
        app.buttons["Yes"].tap()
        sleep(3)
        // ещё раз находим постер
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        // проверяем, что постеры разные
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
//    func testNextIndexLable() {
//
//        let indexLabel = app.staticTexts["Index"]
//        indexLabel.label
//        XCTAssertEqual(indexLabel.label, "1/10")
//    }
    
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
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
//        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
    
//    func testScreenCast() throws {}
    
    //    func testLaunchPerformance() throws {
    //        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
    //            // This measures how long it takes to launch your application.
    //            measure(metrics: [XCTApplicationLaunchMetric()]) {
    //                XCUIApplication().launch()
    //            }
    //        }
    //    }
}
