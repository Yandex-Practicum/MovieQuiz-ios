import Foundation

struct MostPopularMovies {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie {
    let title: String
    let rating: String
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
