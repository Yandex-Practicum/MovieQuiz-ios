//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Виктор Корольков on 22.08.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

class MoviesLoaderTest: XCTestCase {
    func testSuccessLoading() throws {
        
        
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                // сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        
        waitForExpectations(timeout: 1)
        
    }
    
    func testFailureLoading() throws {
        
        let stubNetworkClient = StubNetworkClient(emulateError: true) // говорим, что хотим эмулировать ошибку
            let loader = MoviesLoader(networkClient: stubNetworkClient)
            
            // When
            let expectation = expectation(description: "Loading expectation")
            
            loader.loadMovies { result in
                // Then
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
