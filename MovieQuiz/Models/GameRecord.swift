import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareGameRecord(recordGR: GameRecord) -> Bool {
        self.correct > recordGR.correct
    }
}
