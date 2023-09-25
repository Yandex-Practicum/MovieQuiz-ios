import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    func subtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func multiplication(num1: Int, num2: Int) -> Int {
        return num1 * num2
    }
}

final class MovieQuizTests: XCTestCase {
    
    
    func testAddition() throws {
        
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        let result = arithmeticOperations.addition(num1: num1, num2: num2)
        
        XCTAssertEqual(result, 3)
    }
}
