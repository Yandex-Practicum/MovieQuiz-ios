import Foundation

struct Actor: Decodable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}

struct Movie: Decodable {
  let id: String
  let rank: String
  let title: String
  let fullTitle: String
  let year: String
  let image: String
  let crew: String
  let imDbRating: String
  let imDbRatingCount: String
}

struct Movies: Decodable {
    let items: [Movie]
}
