//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Marina Kolbina on 13/11/2022.
//

import XCTest
@testable import MovieQuiz // импортируем наше приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
     
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}
