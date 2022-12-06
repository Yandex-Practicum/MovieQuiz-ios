import UIKit

final class MovieQuizViewController: UIViewController {
	@IBOutlet private weak var descriptionLabel: UILabel!
	@IBOutlet private weak var counterLabel: UILabel!
	@IBOutlet private weak var posterImageView: UIImageView!
	@IBOutlet private weak var questionLabel: UILabel!
	@IBOutlet private weak var noButton: UIButton!
	@IBOutlet private weak var yesButton: UIButton!
	@IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
	
	private let model = MovieQuizModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		model.onUpdateAnswer = { [weak self] in
			self?.displayAnswer()
		}
		model.onUpdateStep = { [weak self] in
			self?.displayStep()
		}
		model.onUpdateState = { [weak self] in
			self?.displayState()
		}
		
		model.onLoadView()
	}
	
	private func displayAnswer() {
		guard let step = model.currentStep, let answer = step.answer else { return }
		
		noButton.isEnabled = false
		yesButton.isEnabled = false
		
		posterImageView.layer.borderColor = answer == step.correctAnswer ? UIColor.accentOne.cgColor : UIColor.accentTwo.cgColor
	}
	
	private func displayStep() {
		guard let step = model.currentStep else { return }
		posterImageView.layer.borderColor = UIColor.clear.cgColor
		
		noButton.isEnabled = true
		yesButton.isEnabled = true
		
		counterLabel.text = "\(model.currentStepIndex+1)/\(model.steps.count)"
		posterImageView.image = step.image
		questionLabel.text = step.text
	}
	
	private func displayState() {
		switch model.state {
		case .loading:
			displayLoadingState()
		case .running:
			displayRunningState()
		case .finished:
			displayFinishedState()
		case .empty:
			displayEmptyState()
		}
	}
	
	private func displayLoadingState() {
		descriptionLabel.isHidden = true
		counterLabel.isHidden = true
		posterImageView.isHidden = true
		questionLabel.isHidden = true
		noButton.isHidden = true
		yesButton.isHidden = true
		   
		loadingIndicator.startAnimating()
	}
	
	private func displayEmptyState() {
		loadingIndicator.stopAnimating()

		displayAlert(
			title: "Что-то пошло не так(",
			message: "Невозможно загрузить данные",
			action: (title: "Попробовать еще раз", handler: model.onReset)
		)
	}
	
	private func displayRunningState() {
		loadingIndicator.stopAnimating()
		
		descriptionLabel.isHidden = false
		counterLabel.isHidden = false
		posterImageView.isHidden = false
		questionLabel.isHidden = false
		noButton.isHidden = false
		yesButton.isHidden = false
	}
	
	private func displayFinishedState() {
		let title: String
		let message: String?
		
		if model.rounds.count > 1, let lastRound = model.rounds.last {
			var bestRound = lastRound
			var correctAnswersNumber: Double = 0
			var answersNumber: Double = 0
			for round in model.rounds {
				correctAnswersNumber += Double(round.correctAnswersNumber)
				answersNumber += Double(round.answersNumber)
				if round.correctAnswersNumber > bestRound.correctAnswersNumber {
					bestRound = round
				}
			}
			let accuracy = correctAnswersNumber / answersNumber * 100
			title = "Этот раунд окончен!"
			message = """
Ваш результат: \(lastRound.correctAnswersNumber)/\(lastRound.answersNumber)
Количество сыгранных квизов: \(model.rounds.count)
Рекорд: \(bestRound.correctAnswersNumber)/\(bestRound.answersNumber) \(bestRound.date.ddMMYYHHmm)
Средняя точность: \(String(format: "%.2f%%", accuracy))
"""
		} else {
			title = "Раунд окончен!"
			message = nil
		}
		
		displayAlert(
			title: title,
			message: message,
			action: (title: "Сыграть еще раз", handler: model.onReset)
		)
	}
	
	private func displayAlert(
		title: String,
		message: String? = nil,
		action: (title: String, handler: () -> Void)
	) {
		let alert = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: action.title, style: .default, handler: { _ in action.handler() }))
		present(alert, animated: true)
	}
	
	@IBAction private func onTapNoButton(_ sender: UIButton) {
		model.onAnswerNo()
	}
	
	@IBAction private func onTapYesButton(_ sender: UIButton) {
		model.onAnswerYes()
	}
}
