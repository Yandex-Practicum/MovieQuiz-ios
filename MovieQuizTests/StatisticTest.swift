//
//  StatisticTest.swift
//  MovieQuizTests
//
//  Created by Fedor on 25.12.2023.
//

import XCTest
@testable import MovieQuiz

final class StatisticTest:XCTestCase {
   
    func testTotalStatisticCount() throws {
        let stubStatisticImplimintation = StatisticServiceImplementation()
        var count = 5
        let amount = 10
        
        stubStatisticImplimintation.store(correct: count, total: amount)
        var accurancy = stubStatisticImplimintation.totalAccurancy
        count = 3
        stubStatisticImplimintation.store(correct: count, total: amount)
        XCTAssertEqual(stubStatisticImplimintation.totalAccurancy, ((accurancy + 0.3) / Double(stubStatisticImplimintation.gamesCount)))
    }
}
