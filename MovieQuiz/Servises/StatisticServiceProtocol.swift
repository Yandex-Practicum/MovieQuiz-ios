import Foundation

protocol StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }   
    var gamesQuizCount: Int { get set }
    var bestGame: GameRecord { get }
    var questionsAllTheTime: Int {get set}
    var correctAnswersAllTheTime: Int {get set}
    }
