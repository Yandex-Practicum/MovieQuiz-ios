import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let year: String
    let image: String
    let releaseDate: String
    let runtimeMins: String
    let directors: String
    let actorList: [Actor]
}
