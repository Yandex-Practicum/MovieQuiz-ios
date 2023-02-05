import UIKit

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (previousRecord: GameRecord, currentRecord: GameRecord) -> Bool {
        previousRecord.correct < currentRecord.correct
    }
}


