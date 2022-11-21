import Foundation

struct MostPopularMoviesFromConverterResult {
    
    func convert(result: MostPopularMoviesResult.OneMovieResult?) -> OneMovie? {
        guard
            let title       = result?.title,
            let ratingValue = result?.imDbRating,
            let imageUrl    = result?.image
        else {
            
            return nil
        }
        let rating = Double(ratingValue) ?? 7
        return .init(title: title, imageURL: imageUrl, rating: rating)
    }
}
