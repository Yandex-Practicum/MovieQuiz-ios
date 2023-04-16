
import XCTest

struct ArithmeticOperations{
    func addition(num1: Int, num2: Int) -> Int{
        return num1 + num2
    }
    func subtraction(num1: Int, num2: Int) -> Int{
        return num1 - num2
    }
    func multimlication(num1: Int, num2: Int) -> Int{
        return num1 * num2
    }
}

class MovieQuizTests: XCTestCase {
    func textAddition() throws {
        
        // Given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //When
        let result = arithmeticOperations.addition(num1: 1, num2: 2)
        
        //Then
        XCTAssertEqual(result, 3)
    }
}
