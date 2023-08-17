//
//  ArrayTests.swift
//  ArrayTests
//
//  Created by Марат Хасанов on 14.08.2023.
//

import XCTest
import Foundation

@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 1, 2, 3, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutOfRange() throws {
        
        let array = [1, 1, 2, 3, 5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}
