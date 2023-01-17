//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 17.01.2023.
//

import Foundation
import XCTest

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

