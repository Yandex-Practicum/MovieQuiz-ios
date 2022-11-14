import Foundation

struct MostPopularMovies: Codable {
    
    let errorMessage: String
    let items: [MostPopularMovie?]
    
    init(errorMessage: String, items: [MostPopularMovie?]) {
        self.errorMessage = errorMessage
        self.items = [MostPopularMovie?]()
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage) ?? ""
        self.items = try container.decodeIfPresent([MostPopularMovie?].self, forKey: .items) ?? [MostPopularMovie?]()
    }
}

struct MostPopularMovie: Codable {
    
    let title: String
    let rating: Double
    let imageURL: URL?

    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        let ratingValue = try container.decodeIfPresent(String.self, forKey: .rating) ?? "0"
        let rating = Double(ratingValue)
        self.rating = rating ?? 0
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL) ?? URL(string: "https://m.media-amazon.com/images/M/MV5BNjNhZTk0ZmEtNjJhMi00YzFlLWE1MmEtYzM1M2ZmMGMwMTU4XkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_Ratio0.6716_AL_.jpg")
    }
    
    init(title: String, rating: Double, ImageUrl: URL) {
        self.title = ""
        self.rating = 0
        self.imageURL = URL(string: "https://m.media-amazon.com/images/M/MV5BNjNhZTk0ZmEtNjJhMi00YzFlLWE1MmEtYzM1M2ZmMGMwMTU4XkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_Ratio0.6716_AL_.jpg")
    }
}
