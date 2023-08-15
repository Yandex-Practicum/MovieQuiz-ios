import Foundation
import UIKit

struct QuizQuestion{
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let description: String
    let record: String
    let accuracy: String
    let buttonText: String
}
