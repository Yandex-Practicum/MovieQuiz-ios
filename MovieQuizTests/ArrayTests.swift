//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Илья Тимченко on 06.11.2022.
//

import XCTest

@testable import MovieQuiz //импортируем приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let myArray: [Int] = [1,2,3,4,5]
        //When
        let result = myArray[safe: 2]
        //Then
        XCTAssertEqual(result, 3)
        XCTAssertNotNil(result)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let myArray: [Int] = [1,2,3,4,5]
        //When
        let result = myArray[safe: 7]
        //Then
        XCTAssertNil(result)
    }
}
