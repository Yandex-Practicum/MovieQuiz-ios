struct MostPopularMovies: Codable {
    let errorMesage: String
    let items: [MostPopularMovie]
    
    struct MostPopularMovie: Codable {
        let title: String
        let rating: String
        let imageURL: URL
        
        private enum CodingKeys: String, CodingKey {
            case title = "fullTitle"
            case rating = "imDbRating"
            case imageURL = "image"
        }
    }
}
