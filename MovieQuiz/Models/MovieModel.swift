import Foundation

struct Movie: Codable {
    let id: String
    let rank: String
    let title: String
    let year: Int
    let image: String
    let crew: String
    let imDbRating: String
    let imDbRatingCount: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        rank = try container.decode(String.self, forKey: .rank)
        title = try container.decode(String.self, forKey: .title)
        
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else {
            throw ParseError.yearFailure
        }
        self.year = yearValue
        
        image = try container.decode(String.self, forKey: .image)
        crew = try container.decode(String.self, forKey: .crew)
        imDbRating = try container.decode(String.self, forKey: .imDbRating)
        imDbRatingCount = try container.decode(String.self, forKey: .imDbRatingCount)
    }
}

enum CodingKeys: CodingKey {
    case id, title, year, image, releaseDate, runtimeMins, director, actorList
}

enum ParseError: Error {
    case yearFailure
    case runtimeMinsFailure
}

