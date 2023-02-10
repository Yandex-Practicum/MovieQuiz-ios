import UIKit

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        if lhs.total == 0 || rhs.total == 0 {
            return true
        } else {
            let lhsRatio: Double = Double(lhs.correct) / Double(lhs.total)
            let rhsRatio: Double = Double(rhs.correct) / Double(rhs.total)
            
            return lhsRatio < rhsRatio
        }
    }
}
