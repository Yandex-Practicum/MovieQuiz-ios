import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get } //
    var gamesCount: Int { get } // количество сыгранных игр
    var bestGame: GameRecord { get } // лучший счет
}
