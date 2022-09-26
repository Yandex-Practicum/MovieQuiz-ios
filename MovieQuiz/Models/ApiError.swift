import Foundation

enum ApiError: LocalizedError {
    case customError(message: String)
    case codeError(code: Int)
    case emptyResult
    
    var errorDescription: String? {
        switch self {
        case .customError(let message):
            return message
        case .codeError(let code):
            return "Ошибка соединения с сервером \(code)"
        case .emptyResult:
            return "Не удалось загрузить данные"
        }
    }
}
