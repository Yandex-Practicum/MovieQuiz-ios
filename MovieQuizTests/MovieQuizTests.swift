//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by  Игорь Килеев on 19.09.2023.
//

import XCTest

struct ArithmeticOperations {
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

    class MovieQuizTests: XCTestCase {
        func testAddition() throws {
            // Given
            let arithmeticOperations = ArithmeticOperations()
            let num1 = 2
            let num2 = 2
            
            // When
            let expectation = expectation(description: "Addition function expectation")
            
            arithmeticOperations.addition(num1: num1, num2: num2) { result in
                // Then
                XCTAssertEqual(result, 4)
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1.3)
        }
    }
    


