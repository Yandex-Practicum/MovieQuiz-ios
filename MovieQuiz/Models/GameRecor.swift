import Foundation

// MARK: - GameRecord

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

// MARK: - Extension GameRecord

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
