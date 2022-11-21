import Foundation

struct MostPopularMoviesResult: Codable {
    let items: [OneMovieResult?]
    let errorMessage: String?
    
    struct OneMovieResult: Codable {
        let title: String?
        let image: URL?
        let imDbRating: String?
    }
}


