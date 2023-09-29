//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Дмитрий Калько on 28.09.2023.
//

import Foundation
import XCTest //импорт фреймворка тсетирования
@testable import MovieQuiz //импртируем наше приложение ля тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { //тест на успешное взятие элемента по индексу
        //given
        let array = [1, 1, 2, 3, 5]
        
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws { //тест на взятие элемента по неправильному индексу
        //given
        let array = [1, 1, 2, 3, 5]
        
        //when
        let value = array[safe: 20]
        
        //then
        XCTAssertNil(value)
    }
}
