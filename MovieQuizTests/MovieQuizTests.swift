import XCTest

struct ArithmeticOperations {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func subtraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}


final class MovieQuizTests: XCTestCase {
    
    func testAddition() throws {
        
        //given
        let arithmeticOperations = ArithmeticOperations()
        let num1 = 1
        let num2 = 2
        
        //when
        let expectation = expectation(description: "Addition function expectation")
        
        arithmeticOperations.addition(num1: num1, num2: num2) { result in
            
            //then
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
