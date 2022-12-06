import Foundation

enum Errors: String, Error {
    case itemsEmpty
    case decodingError
    case invalidResponse
    case offline
    case invalidURL
    case parsingError
    case exceedAPIRequestLimit
    case testError = "Test Error"
}

extension Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Не можем загрузить картинку",
                                     comment: "Попробуйте еще раз!")
        case .itemsEmpty:
            return NSLocalizedString("Пустой массив",
                                     comment: "Данные не загрузились")
        case .offline:
            return NSLocalizedString("Нет подключения к интернету",
                                     comment: "Проверьте интернет соединение")
        case .invalidResponse:
            return NSLocalizedString("Ошибка запроса",
                                     comment: "Проверьте соединение")
        case .decodingError:
            return NSLocalizedString("Ошибка де-кодировки",
                                     comment: "Ошибка де-кодировки")
        case .parsingError:
            return NSLocalizedString("Невозможно получить данные",
                                     comment: "Нет комментариев")
        case .exceedAPIRequestLimit:
            return NSLocalizedString("Превышено максимальное число запросов на сегодня",
                                     comment: "Максимальное число запросов 100 в день")
        case .testError:
            return NSLocalizedString("Test Error",
                                     comment: "Test Error")
        }
    }
}

