//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Антон Павлов on 11.07.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testGetValueInRnge() throws {
//        Дано
        let array = [1,1,2,3,5]
//        Когда
        let value = array[safe:2]
        
//        Тогда
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
       
//        Дано
        let array = [1,1,2,3,5]
//         Когда
        let value = array[safe: 20]
        
//        Тогда
        XCTAssertNil(value)
    }
}
