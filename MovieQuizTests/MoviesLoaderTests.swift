//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Александр Зиновьев on 30.11.2022.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {

    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectations = expectation(description: "Loading Expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.count, 2)
                expectations.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let expectation = expectation(description: "Failure loading Expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, Errors.testError)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
