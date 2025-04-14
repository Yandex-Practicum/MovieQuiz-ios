//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Федор Завьялов on 14.12.2023.
//

import XCTest
@testable import MovieQuiz

final class ArrayTest: XCTestCase {

    func testGetIndexInRange() throws {
        //Given
        let array = [1, 2, 4, 2, 2, 4]
        //When
        let number = array[safe: 3]
        //Then
        XCTAssertNotNil(number)
        XCTAssertEqual(number, 2)
    }
    
    func testGetIndexOutOfRange() throws {
        //Given
        let array = [1,1,3,4,2,1]
        //When
        let number = array[safe: 20]
        //Then
        XCTAssertNil(number)
    }
    
}
