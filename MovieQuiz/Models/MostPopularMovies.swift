import Foundation

//MARK: - Модель данных

struct MostPopularMovies: Codable {
    let errorMassage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageUrl: URL {
        let urlString = imageURL.absoluteString // создаем строку из адреса
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._VO_UX600_.jpg"  //  обрезаем лишнюю часть и добавляем модификатор желаемого качества
        
        guard let newUrl = URL(string: imageUrlString) else { // пытаемся создать новый адрес, если не получается возвращаем старый
            return imageURL
        }
        
        return newUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
