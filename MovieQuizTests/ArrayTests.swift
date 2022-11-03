import Foundation
import XCTest
@testable import MovieQuiz // импортируем наше приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
       // Given
       let array = [1, 1, 2, 3, 5]
       // When
       let value = array[safe: 2]
       // Then
        XCTAssertEqual(value, 2)
        XCTAssertNotNil(value)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
       let array = [1, 2, 3, 4, 5, 8]
       // When
       let value = array[safe: 8]
       // Then
        XCTAssertNil(value)
    }
}
