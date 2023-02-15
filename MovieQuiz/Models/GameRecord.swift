import Foundation

struct GameRecord: Comparable, Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lsh: GameRecord, rsh: GameRecord) -> Bool {
        return lsh.correct < rsh.correct
    }
}
