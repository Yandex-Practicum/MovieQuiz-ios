//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Ruslan Batalov on 10.12.2022.
//

import XCTest




class MovieQuizUITests: XCTestCase {
    
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
        let firstPoster = app.images["Poster"]
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertTrue(indexLabel.label == "2/10")
        
        
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
    
    func testGameStop() {
        let button = app.buttons["Yes"]
        for _ in 1...10 {
            button.tap()
            sleep(1)
        }
        
        let alert = app.alerts["alert"]
        XCTAssertTrue(app.alerts["alert"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
        
        alert.buttons.firstMatch.tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
        
    }
    
   
    
    
    
}
