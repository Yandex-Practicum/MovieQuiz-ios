//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Владимир Клевцов on 12.6.23..
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 200]
        //Then
        XCTAssertNil(value)
    }
}
