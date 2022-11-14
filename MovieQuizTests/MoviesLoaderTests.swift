//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Роман Бойко on 11/12/22.
//

import Foundation
// Import framework for tests
import XCTest
// Import app for testing
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading () throws {
        // Given
        
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        
        // Так как функция асинхронная,нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failture")
            }
            
        }
        
        // Then
        
        waitForExpectations(timeout: 1)
    }
    
    func testFaltureLoadng() throws {
        // Given
        
        let stabNetworkClient = StubNetworkClient(emulateError: true)
        
        let loader = MoviesLoader(networkClient: stabNetworkClient)
        
        // When
        
        let expection = expectation(description: "Loading expection")
        
        loader.loadMovies{ result in
            switch result {
            case .success(_):
                XCTFail("Unexpected failture")
            case .failure(let error):
                XCTAssertNotNil(error)
                expection.fulfill()
            }
        }
        // Then
        
        waitForExpectations(timeout: 1)
    }
}

struct StubNetworkClient: NetworkRouting {
    
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    func fetch (url: URL, handler: @escaping (Result <Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponce))
        }
    }
    
    private var expectedResponce: Data {
                """
                {
                   "errorMessage" : "",
                   "items" : [
                      {
                         "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                         "fullTitle" : "Prey (2022)",
                         "id" : "tt11866324",
                         "imDbRating" : "7.2",
                         "imDbRatingCount" : "93332",
                         "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                         "rank" : "1",
                         "rankUpDown" : "+23",
                         "title" : "Prey",
                         "year" : "2022"
                      },
                      {
                         "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                         "fullTitle" : "The Gray Man (2022)",
                         "id" : "tt1649418",
                         "imDbRating" : "6.5",
                         "imDbRatingCount" : "132890",
                         "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                         "rank" : "2",
                         "rankUpDown" : "-1",
                         "title" : "The Gray Man",
                         "year" : "2022"
                      }
                    ]
                  }
                """.data(using: .utf8) ?? Data()
    }
}
