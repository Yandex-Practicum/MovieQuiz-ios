//
//  MovieQuizUITest.swift
//  MovieQuizUITest
//
//  Created by Александр Ершов on 10.01.2023.
//

import XCTest

final class MovieQuizUITest: XCTestCase {
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
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        let firstPoster = app.images["Poster"] // Находим первоначальный постер

        app.buttons["Yes"].tap() // Находим кнопку Да и нажимаем на нее
        
                let secondPoster = app.images["Poster"] // Повтор постера
        sleep (3)
        XCTAssertFalse(firstPoster==secondPoster)
        sleep (3)
        XCTAssertTrue(indexLabel.label == "2/10")
        
    }
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testAlert(){
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
        }
         
         sleep(2)
         
         let alert = app.alerts["AlertResult"]
         
         XCTAssertTrue(app.alerts["AlertResult"].exists)
         XCTAssertTrue(alert.label == "Этот раунд окончен!")
         XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
     }

     func testAlertDismiss() {
         for _ in 1...10 {
             app.buttons["No"].tap()
         }
         
         sleep(2)
         
         let alert = app.alerts["AlertResult"]
         alert.buttons.firstMatch.tap()
         
         sleep(2)
         
         let indexLabel = app.staticTexts["Index"]
         
         XCTAssertFalse(app.alerts["AlertResult"].exists)
         XCTAssertTrue(indexLabel.label == "1/10")
     }
    
}


