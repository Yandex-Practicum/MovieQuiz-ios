import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    //MARK: - тест на успешное взятие элемента по индексу
    
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        
        //When
        let value = array[safe: 2]
        
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    //MARK: - тест на взятие элемента по неправильному индексу
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        //When
        let value = array[safe: 20]
        
        //Then
        XCTAssertNil(value)
        
    }
}
