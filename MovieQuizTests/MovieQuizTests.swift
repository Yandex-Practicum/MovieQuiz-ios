//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Виктор Корольков on 22.08.2023.
//

import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

class re: XCTestCase {
    func testAddition() throws {
        let arithmeticOperations = ArithmeticOperations()
            let num1 = 1
            let num2 = 2
        
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        XCTAssertEqual(result, 3)
    }
}
