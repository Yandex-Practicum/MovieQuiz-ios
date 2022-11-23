import Foundation

struct FromOptionalResultToNonOptional {
    
    func convert(result: MostPopularMoviesResult.OneMovieResult?) -> OneMovie? {
        guard
            let title       = result?.title,
            let imageUrl    = result?.image
        else {
            return nil
        }
        
        var rating: Double {
            Double(result?.imDbRating ?? "7") ?? 7
        }
        return .init(title: title, imageURL: imageUrl, rating: rating)
    }
}
