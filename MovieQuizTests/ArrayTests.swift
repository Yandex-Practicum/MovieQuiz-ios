import XCTest // Импортируем фреймворк XCTest для тестирования
@testable import MovieQuiz // Импортируем приложение для тестирования

class ArrayTest: XCTestCase {
    
    func testGetValueInRange() throws { // Тест на успешное взятие элемента по индексу
        
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    func testGetValueOutOfRange() throws { // Тест на взятие элемента по неправильному индексу
        
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
}




