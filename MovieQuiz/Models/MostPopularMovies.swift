import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [PopularMovie]
}

struct PopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
