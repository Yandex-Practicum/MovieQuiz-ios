import UIKit

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}

extension Array where Element == QuizQuestion {
	var asSteps: [MovieQuizModel.QuizStep] {
		map {
			MovieQuizModel.QuizStep(
				image: UIImage(named: $0.image),
				text: $0.text,
				correctAnswer: $0.correctAnswer
			)
		}
	}
}
