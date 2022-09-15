import UIKit

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date

    var score: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }

    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.score < rhs.score
    }
}
