//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Илья Тимченко on 06.11.2022.
//

import XCTest // Фреймфорк для тестирования. Содержит все инструменты, необходимые для создания и запуска unit-тестов

//MARK: "XCTestCase" - Базовый класс для всех тестов.
final class MovieQuizTests: XCTestCase {
    
    //MARK: Функции, которые будут вызваны а) перед каждым тестом — "setUpWithError", б) после каждого теста — "tearDownWithError".
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: Это сам тест. Тесты — это функции внутри нашего класса, которые начинаются со слова test.
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    //MARK: Это нагрузочный тест. В нём можно измерить, сколько времени на выполнение потребует та или иная функция.
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
