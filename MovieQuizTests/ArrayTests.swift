//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Артур  Арсланов on 07.01.2024.
//

import XCTest
@testable import MovieQuiz // импортируем наше приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1,2,3,4,5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value,3)
    }
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
        let array = [1,2,3,4,5]
        // When
        let value = array[safe:20]
        // Then
        XCTAssertNil(value)
    }
}
