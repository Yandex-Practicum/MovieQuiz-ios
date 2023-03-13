
import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var totalAccuracy: Double { get }

    
}
