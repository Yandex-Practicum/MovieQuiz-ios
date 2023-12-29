//
//  StatisticTest.swift
//  MovieQuizTests
//
//  Created by Fedor on 25.12.2023.
//

import XCTest
@testable import MovieQuiz


extension StatisticServiceImplementation {
    func getCurrentStatistic() -> Double {
        return totalAccurancy * Double(gamesCount)
    }
}
final class StatisticTest: XCTestCase {
   
    func testTotalStatisticCount() throws {
        let stubStatisticImplimintation = StatisticServiceImplementation()
        let count = 5
        let amount = 10
        let accurancy = stubStatisticImplimintation.getCurrentStatistic()
        stubStatisticImplimintation.store(correct: count, total: amount)
        XCTAssertEqual(stubStatisticImplimintation.totalAccurancy, (accurancy + 0.5) / Double(stubStatisticImplimintation.gamesCount))
    }
}
