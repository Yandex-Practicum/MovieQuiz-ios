//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Александр Ершов on 08.01.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz // импорт приложения для теста

class ArayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на правильный индекс
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutRange() throws{ // тест на неправильный индекс
    //Given
        let array = [1, 1, 2, 3, 5]
    // When
        let value = array[safe: 20]
    // Then
        XCTAssertNil(value)
    }
}
