import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    var date = Date()
}
