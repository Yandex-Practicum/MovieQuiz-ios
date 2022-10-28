import Foundation

protocol StatisticService {
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}

