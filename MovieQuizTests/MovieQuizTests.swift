//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Кирилл Марьясов on 10.03.2024.
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

class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.addition(num1: 1, num2: 2)
        XCTAssertEqual(result, 3)
    }
}
