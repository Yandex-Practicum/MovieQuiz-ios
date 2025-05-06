import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(_ another: GameRecord) -> Bool {
        return correct < another.correct
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return "\(correct)/\(total) (\(dateFormatter.string(from: date)))"
    }
}
