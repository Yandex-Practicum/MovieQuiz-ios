import Foundation

struct GameRecord: Codable, Comparable {
    
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (prevValue: GameRecord, newValue: GameRecord) -> Bool {
        return prevValue.correct < newValue.correct
    }
    func toString () -> String {
        ("\(correct)/\(total) \(date.dateTimeString)")
    }
}


