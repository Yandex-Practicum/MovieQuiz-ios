import Foundation

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable{
    private var accuracy: Double{
        guard total != 0 else{
            return 0
        }
        return Double(correct) / Double(total)
        
    }
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
    
    
}
