//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by  Игорь Килеев on 21.09.2023.
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
    
    

    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
       // XCTAssertTrue(firstPoster.exists)
        app.buttons["Yes"].tap() // находим кнопку Да и нажимаем ее
        sleep(3)
        
        let secondPoster = app.images["Poster"] // еще раз находим постер
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        //XCTAssertNotEqual(secondPosterData, firstPosterData)
        XCTAssertFalse(firstPosterData == secondPosterData)
        //XCTAssertTrue(secondPoster.exists)
        //XCTAssertFalse(firstPoster == secondPoster) // проверяем что постеры разные
        let indexLabel = app.staticTexts["Index"]
     
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    func testNoButton() {
        sleep(2)
        let onePoster = app.images["Poster"]
        let onePosterData = onePoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(2)
        
        let twoPoster = app.images["Poster"]
        let twoPosterData = twoPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(onePosterData == twoPosterData)
        
        let indxlabel = app.staticTexts["Index"]
        XCTAssertTrue(indxlabel.label == "2/10")
    }
    
    func testAllert() {
        sleep(1)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(1)
        }
   
        let alertDone = app.alerts["Игра Окончена"]
       
        XCTAssertTrue(alertDone.exists)
        XCTAssertTrue(alertDone.label == "Игра Окончена")
        XCTAssertTrue(alertDone.buttons.firstMatch.label == "OK")
        //let alertLabelDone = alertDone.label
        //let alertButtonDone = alertDone.buttons.firstMatch.label
        
       // XCTAssertNotEqual(alertLabelDone, alertButtonDone)
        
        
        
    }
    
}
   

