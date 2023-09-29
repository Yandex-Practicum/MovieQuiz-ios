//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Дмитрий Калько on 28.09.2023.
//
//import Foundation
import XCTest
//@testable import MovieQuiz


class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    /*    func testExample() throws {
     // UI tests must launch the application that they test.
     let app = XCUIApplication()
     app.launch()
     
     // Use XCTAssert and related functions to verify your tests produce the correct results.
     }
     */
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] //находим ервоначаоьный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() //находим кнопку да и нажимаем на нее
        sleep(3)
        
        let secondPoster = app.images["Poster"] // находим второй постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем что постеры отличаются
        
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] //находим ервоначаоьный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() //находим кнопку да и нажимаем на нее
        sleep(3)
        
        let secondPoster = app.images["Poster"] // находим второй постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем что постеры отличаются
        
    }
    
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alert = app.alerts["Game"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз!")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
