//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Илья Тимченко on 06.11.2022.
//

import XCTest // Фреймфорк для тестирования. Содержит все инструменты, необходимые для создания и запуска unit-тестов

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

//MARK: "XCTestCase" - Базовый класс для всех тестов.
final class MovieQuizTests: XCTestCase {
    func testAddiction() throws {
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        let expectation = expectation(description: "Функция выполнена")
        
        arithmeticOperations.addition(num1: num1, num2: num2) { result in
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
