//
//  NetworkError.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 17.01.2024.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case loadImageError, codeError, dataError
    var errorDescription: String? {
        switch self {
        case .loadImageError:
            return NSLocalizedString("Не удалось загрузить изображение", comment: "")
        case .codeError:
            return NSLocalizedString("Ошибка данных. Проверьте подключение к интернету.", comment: "")
        case .dataError:
            return NSLocalizedString("Ошибка данных. Проверьте подключение к интернету.", comment: "")
        }
    }
}
