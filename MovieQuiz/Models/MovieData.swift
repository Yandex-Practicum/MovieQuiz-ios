import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else {
            throw ParseError.yearFailure
        }
        self.year = yearValue
                
        image = try container.decode(String.self, forKey: .image)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        
        let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
        guard let runtimeMinsValue = Int(runtimeMins) else {
            throw ParseError.runtimeMins
        }
        self.runtimeMins = runtimeMinsValue
        
        directors = try container.decode(String.self, forKey: .directors)
        actorList = try container.decode([Actor].self, forKey: .actorList)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, year, image, releaseDate, runtimeMins, directors, actorList
    }
    
    enum ParseError: Error {
        case yearFailure
        case runtimeMins
    }
}

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}



