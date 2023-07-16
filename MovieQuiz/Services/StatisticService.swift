import UIKit

protocol StatisticService {
    /// средняя точность правильных ответов за все сыгранные квизы
    var averageAccuracy: Double { get }
    /// количество сыгранных квизов
    var gamesCount: Int { get }
    /// лучший счет за все сыгранные квизы
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int) 
}
