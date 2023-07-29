import XCTest

@testable import MovieQuiz

class ArrayTest : XCTest {
    
    func testGetValueInRange() throws {
        // Given
        let array = [1,1,2,3,5]
       // When
       let value = array[safe: 2]
       // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1,1,2,3,5]
       // When
       let value = array[safe: 2]
       // Then
        XCTAssertNil(value)
    }
}


