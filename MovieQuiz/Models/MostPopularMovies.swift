import Foundation

struct MostPopularMovies {
    var items: [OneMovie]
    let errorMessage: String
}
struct OneMovie {
    let title: String
    let imageURL: URL
    let rating: Double
    
    var resizedImageURL: URL {
        let absoluteString = imageURL.absoluteString
        let imageUrlString = absoluteString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        guard let newUrl = URL(string: imageUrlString) else {
            return imageURL
        }
        return newUrl
    }
}


