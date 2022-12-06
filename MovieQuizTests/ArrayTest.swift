//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Александр Зиновьев on 25.11.2022.
//

import XCTest
@testable import MovieQuiz

final class ArrayTest: XCTestCase {
    
    func testGetValueInRange() throws {
        // Given
        let array = [1,2,3,4,5,6]
        
        // When
        let result = array[safe: 5]
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 6)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [0,1,2,3,4,5,6]
        
        // When
        let result = array[safe: -1]
        
        // Then
        XCTAssertNil(result)
    }
}
