// swiftlint:disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Структуры для состояний
    
    // "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questuinNumber: String
    }
    
    // "Результат квиза"
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    
}
