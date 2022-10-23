import Foundation

struct QuizQuestion: Equatable {
    let image: Data
    let text: String
    let correctAnswer: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.text == rhs.text && lhs.image == rhs.image && lhs.correctAnswer == rhs.correctAnswer
    }
}
