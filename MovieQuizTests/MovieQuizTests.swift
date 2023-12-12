//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Федор Завьялов on 12.12.2023.
//

import XCTest

struct ArithmeticOperations {
    
    func addition(numb1: Int, numb2: Int) -> Int{
        return numb1 + numb2
    }
    
    func substruction ( numb1: Int, numb2: Int) -> Int {
        return numb1 - numb2
    }
    
    func multiplication (numb1: Int, numb2: Int) -> Int {
        return numb1 * numb2
    }
    
}

struct ArithmeticOperationsDispatched {
    
    func addition(numb1: Int, numb2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(numb1 + numb2)
        }
    }
    
    func substruction ( numb1: Int, numb2: Int) -> Int {
        return numb1 - numb2
    }
    
    func multiplication (numb1: Int, numb2: Int) -> Int {
        return numb1 * numb2
    }
    
}

final class MovieQuizTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddition() throws {
        //Given
        let arithmeticOperations = ArithmeticOperations()
        let numb1 = 1
        let numb2 = 2
        
        //When
        let addition = arithmeticOperations.addition(numb1: numb1, numb2: numb2)
        
        //Then
        XCTAssertEqual(addition, 3  , "Unexpected value")
    }
    
    func testAdditionsDispatched() throws {
        let arithmeticOperationsDispatched = ArithmeticOperationsDispatched()
        let numb1 = 1
        let numb2 = 2
        
        //Whne
        
       let expectation = expectation(description: "Addition expectation")
        arithmeticOperationsDispatched.addition(numb1: numb1, numb2: numb2) { result in
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
