import Foundation
private func show(quiz result: QuizResultsViewModel) {
    let alert = UIAlertController(
        title: result.title,
        message: result.text,
        preferredStyle: .alert)
    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
        guard let self = self else { return }
        
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
        guard let self = self else { return }
        self.showNextQuestionOrResults()
    }
}
