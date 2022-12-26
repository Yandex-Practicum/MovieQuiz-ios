import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    var date: Date
}

// MARK: - Comparable
extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
