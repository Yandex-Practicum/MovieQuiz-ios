

import Foundation

enum Errors: Error {
    case errorLoadImage, codeError, errorDataLoad
    
    var errorText: String {
        switch self {
        case .errorLoadImage:
            return "Возникла проблема с загрузкой! Повторите, пожалуйста снова!"
        case .codeError:
            return "Возникла ошибка! Повторите, пожалуйста снова!"
        case .errorDataLoad:
            return "Ошибка сети! Повторите, пожалуйста снова!"
            
        }
    }
}
