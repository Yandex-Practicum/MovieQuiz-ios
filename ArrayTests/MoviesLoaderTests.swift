//
//  MoviesLoaderTests.swift
//  MoviesLoaderTests
//
//  Created by Марат Хасанов on 14.08.2023.
//

import XCTest
import Foundation

@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader()
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
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
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader()
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
