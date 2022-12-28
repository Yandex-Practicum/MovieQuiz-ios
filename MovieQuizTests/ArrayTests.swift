//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Кирилл Брызгунов on 01.12.2022.
//

import Foundation
import XCTest // импорт фреймворка
@testable import MovieQuiz // импортируем приложение

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        //Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        //Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 21]
        
        // Then
        XCTAssertNil(value)
    }
}
