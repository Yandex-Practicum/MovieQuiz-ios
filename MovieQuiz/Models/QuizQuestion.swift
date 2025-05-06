import Foundation

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.text != rhs.text, lhs.image != rhs.image, lhs.correctAnswer != rhs.correctAnswer { return false }
        return true
    }
}
