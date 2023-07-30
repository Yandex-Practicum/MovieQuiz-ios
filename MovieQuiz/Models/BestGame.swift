import Foundation

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: BestGame) -> Bool {
        correct > another.correct
    }
}


