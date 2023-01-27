//
//  ErrorsModel.swift
//  MovieQuiz
//
//  Created by Келлер Дмитрий on 27.01.2023.
//

import Foundation

enum Errors: Error {
    case errorLoadImage, codeError, errorDataLoad
    
    var errorText: String {
        switch self {
        case .errorLoadImage:
            return "Возникла проблема при загрузке изображения! Повторите, пожалуйста снова!"
        case .codeError:
            return "Возникла ошибка при загрузке данных! Повторите, пожалуйста снова!"
        case .errorDataLoad:
            return "Ошибка сети! Повторите, пожалуйста снова!"
            
        }
    }
}
