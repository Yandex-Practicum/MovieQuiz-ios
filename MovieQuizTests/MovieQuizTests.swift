//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Марат Хасанов on 11.08.2023.
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
    func testAddition() throws {
        let arithmeticOperations = ArithmeticOperations()
        let result = arithmeticOperations.addition(num1: 1, num2: 2)
        XCTAssertEqual(result, 3) // сравниваем результат выполнения функции и наши ожидания
    } 
}
