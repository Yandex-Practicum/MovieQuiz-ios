//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Ruslan Batalov on 10.12.2022.
//

import XCTest



class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        // Дано
        let arthimeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        //Когда
        let exp = expectation(description: "VVVV")
        arthimeticOperations.addition(num1: num1, num2: num2) { result in
            XCTAssertEqual(result, 3)
            exp.fulfill()
           
        }
        // Тогда
        waitForExpectations(timeout: 2)
           
    }
    
}

