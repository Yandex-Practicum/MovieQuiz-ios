// swiftlint:disable all
//
// Model данных для фильмов
//

import Foundation

struct Movies: Codable {
    enum CodingKeys: String, CodingKey {
        case moviesList = "items"
    }
    
    let moviesList: [Movie]
    
    struct Movie: Codable {
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
    
}
