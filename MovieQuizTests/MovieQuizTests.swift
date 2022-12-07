//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Respect on 07.12.2022.
//

import XCTest

struct ArithmeticOperation {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}

final class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        //Given - Дано
        let arithmeticOperation = ArithmeticOperation()
        let num1 = 1
        let num2 = 2
        
        // When - Когда
        let expectation = expectation(description: "Addition function expectation"
        )
        arithmeticOperation.addition(num1: num1, num2: num2) { result in
            //Then - Тогда
            XCTAssertEqual(result, 3) // Сравниваем два значения и маркируем тест как true или false
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}

