//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Сергей Баскаков on 16.02.2024.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }     
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

class MovieQuizTests: XCTestCase {
    
    func testAddition() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.addition(num1: 1, num2: 2)
        XCTAssertEqual(result, 3)
    }
    
    func testSubtraction() throws {
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 3
        let num2 = 2
        let expectation = expectation(description: "Subtraction function expectation")
        arithmeticOperations.subtraction(num1: num1, num2: num2){ result in
            XCTAssertEqual(result, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
        
    }


}
