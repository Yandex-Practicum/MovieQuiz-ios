

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        let lhsAccuracy = Double(lhs.correct / lhs.total)
        let rhsAccuracy = Double(rhs.correct / rhs.total)
        return lhsAccuracy < rhsAccuracy
    }
}
