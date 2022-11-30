//
//  Errors.swift
//  MovieQuiz
//
//  Created by Veniamin on 29.11.2022.
//

import Foundation

enum ErrorList: LocalizedError{
    case imageError
    case loadError
    var localizedDescription: String {
        switch self {
        case .imageError:
            return "Ошибка с загрузкой изображения"
        case .loadError:
            return "Ошибка с загрузкой данных"
        }
    }
}
