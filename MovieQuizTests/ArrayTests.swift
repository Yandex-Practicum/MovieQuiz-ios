//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Mikhail Vostrikov on 24.05.2023.
//

import XCTest
@testable import MovieQuiz

class ArraeTests: XCTestCase {
    func testGetValueInRage() throws { // тест на успешное взятие элемента по индексу
        //Given
        let array = [1, 2, 3, 4, 5]
        
        //When
        let value = array [safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
        
    }
    
    func testGetOutOfRage() throws { // тест на взятие элемента по неправильному индексу
        //Given
        let array = [1, 2, 3, 4, 5]
        
        //When
        let value = array [safe: 20]
        
        //Then
        XCTAssertNil(value)
        
    }
}
