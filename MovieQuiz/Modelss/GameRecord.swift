import Foundation

struct GameRecord: Codable {
    
    private enum Keys: CodingKey {
        case correct, total, date
    }
    
    let correct: Int
    let total: Int
    let date: Date
    
    init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Keys.self)
            self.correct = try container.decode(Int.self, forKey: .correct)
            self.total = try container.decode(Int.self, forKey: .total)
            self.date = try container.decode(Date.self, forKey: .date)
        }
    
    init(correct: Int, total: Int, date: Date) {
        self.correct = correct
        self.total = total
        self.date = date
    }
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct < another.correct
    }
}
