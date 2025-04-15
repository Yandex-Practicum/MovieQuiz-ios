//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Дмитрий Калько on 28.09.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    
    func testsSuccessLoading() throws {
        
        //given
        let stubNetworkClient = StubNetworkClient(emulateError: false) //не хотим эмклировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //when
        //так как функция загрузки фильмов основная нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //then
            switch result {
            case.success(let movies):
                //проверяем что пришло 2 фильма как в тестовм
                XCTAssertEqual(movies.items.count, 2)
                //сравниваем данные с тем, что мы предполагаем
                expectation.fulfill()
            case.failure(_):
                //мы не ожидаем, что пришла ошибка, есло она появится, надо бкудет провалить тест
                XCTFail("Unexpected failure") //функция которая проваливает тест
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        
        //given
        let stubNetworkClient = StubNetworkClient(emulateError: true) //обрабатываем ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //when
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //then
            switch result {
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case.success(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}

struct StubNetworkClient: NetworkRouting {
    
    enum TestError: Error { //тестовая ошибка
        case test
    }
    
    let emulateError: Bool // этот параметр нужен чтобы эмулировала либо ошибку сеи либо успешный ответ
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }
    
    private var expectedResponse: Data {
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
