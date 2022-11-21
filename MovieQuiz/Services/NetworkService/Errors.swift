import Foundation

enum Errors: Error {
    // Знаю что мог добавить сюда весь текст как rowValue,
    // но хотел использовать assoсiated values но что то недоразобрался
    // что с ними делать и зачем они мне нужны
    case itemsEmpty
    case decodingError
    case invalidResponse
    case offline
    case invalidURL
    case parsingError
    case exceedAPIRequestLimit
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
            return NSLocalizedString("Превышено максимальное число запросов",
                                     comment: "Максимальное число запросов 100 в день")
        }
    }
}
