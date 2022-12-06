import UIKit

final class MovieQuizModel {
	var onUpdateAnswer: () -> Void = {}
	var onUpdateStep: () -> Void = {}
	var onUpdateState: () -> Void = {}
	
	private(set) var state: State = .loading { didSet { onUpdateState() } }
	
	private(set) var steps: [QuizStep] = [] { didSet { onUpdateAnswer() } }
	
	private(set) var currentStepIndex = 0 { didSet { onUpdateStep() } }
	
	var currentStep: QuizStep? {
		steps[safe: currentStepIndex]
	}
	
	private(set) var rounds: [QuizRound] = []
	
	func onLoadView() {
		onReset()
	}
	
	func onAnswerYes() {
		onAnswer(true)
	}
	
	func onAnswerNo() {
		onAnswer(false)
	}
	
	func onReset() {
		state = .loading
		loadSteps()
	}
	
	private func loadSteps() {
		steps = QuizQuestion.Mock.dataSource.asSteps
		currentStepIndex = 0
		state = .running
	}
	
	private func onAnswer(_ answer: Bool) {
		guard state == .running else { return }

		steps[currentStepIndex].answer = answer
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
			self?.goToNextStep()
		}
	}
	
	private func goToNextStep() {
		let nextStepIndex = currentStepIndex + 1
		
		if nextStepIndex < steps.count {
			currentStepIndex = nextStepIndex
		} else {
			rounds.append(
				QuizRound(
					correctAnswersNumber: steps.filter { $0.answer == $0.correctAnswer }.count,
					answersNumber: steps.count,
					date: Date()
				)
			)
			state = .finished
		}
	}
}
