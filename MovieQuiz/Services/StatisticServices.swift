import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCoint: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    
}
