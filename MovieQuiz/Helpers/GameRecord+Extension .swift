import Foundation

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct > rhs.correct
    }
    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct == rhs.correct
    }
}
