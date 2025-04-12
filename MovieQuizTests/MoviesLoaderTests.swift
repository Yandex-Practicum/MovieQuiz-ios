//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Александр Верповский on 10.04.2024.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected success")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
