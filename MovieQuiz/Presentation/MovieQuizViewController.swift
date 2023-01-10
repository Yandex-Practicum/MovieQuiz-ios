import UIKit

final class MovieQuizViewController: UIViewController {
	// MARK: Все переменные
	private var questions: [QuizQuestion] = [
		QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)]
	private var currentQuestionIndex: Int = 0
	private var correctAnswers: Int = 0
	private var countOfQuations: Int { questions.count }
	
	// MARK: Запуск экрана
    override func viewDidLoad() {
        super.viewDidLoad()
		showQuiz(quiz: convert(model: questions[0]))
//		imageView.layer.masksToBounds = true
//		imageView.layer.borderWidth = 1
//		imageView.layer.borderColor = UIColor.white.cgColor
		imageView.layer.cornerRadius = 6
    }
	// MARK: View модели для состояний
	
	// Вью-модель для состояния "Вопрос задан"
	private struct QuizStepViewModel {
	  let image: UIImage
	  let question: String
	  let questionNumber: String
	}
	/// Вью-модель для состояния "Результат квиза"
	private struct QuizResultsViewModel {
	  let title: String
	  let text: String
	  let buttonText: String
	}
	/// структура вопроса
	private struct QuizQuestion {
	  let image: String
	  let text: String
	  let correctAnswer: Bool
	}
	
	/// функция конвертации вопроса в модель
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
								 question: model.text,
								 questionNumber: "\(1)/\(10)")
	}
	/// здесь мы заполняем нашу картинку, текст и счётчик данными
	private func showQuiz(quiz step: QuizStepViewModel) {
		imageView.image = step.image
		textLabel.text = step.question
		counterLabel.text = "\(currentQuestionIndex+1)/\(countOfQuations)"
	}
	/// Функция, показывающая реакцию квиза на правильный / неправильный ответ
	private func showAnswerResult(isCorrect: Bool) {
		imageView.layer.masksToBounds = true
		switch isCorrect {
		case true:
			correctAnswers += 1
			imageView.layer.borderColor = UIColor.ypGreen.cgColor
			imageView.layer.borderWidth = 8
		case false:
			imageView.layer.borderColor = UIColor.ypRed.cgColor
			imageView.layer.borderWidth = 8
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
			self.showNextQuestionOrResults()
		}
		
	}
	/// Функция для перехода к следующему вопросу или результату квиза
	private func showNextQuestionOrResults() {
		self.imageView.layer.borderWidth = 0
		currentQuestionIndex += 1
		if currentQuestionIndex == countOfQuations {
			// создаём объекты всплывающего окна
			let alert = UIAlertController(title: "Сыграть ещё раз?",
										  message: "Вы ответили верно на \(correctAnswers) из \(countOfQuations)",
										  preferredStyle: .alert)
			let action = UIAlertAction(title: "Ещё раз!", style: .default, handler: { _ in
				self.currentQuestionIndex = 0
				self.showQuiz(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
				self.correctAnswers = 0
			})
			alert.addAction(action)
			self.present(alert, animated: true, completion: nil)
		} else {
			showQuiz(quiz: convert(model: questions[currentQuestionIndex]))
		}
	}
	
	
	
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		let currentQuestion = questions[currentQuestionIndex]
		let givenAnsver = false
		showAnswerResult(isCorrect: givenAnsver == currentQuestion.correctAnswer)
	}
	
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		let currentQuestion = questions[currentQuestionIndex]
		let givenAnsver = true
		showAnswerResult(isCorrect: givenAnsver == currentQuestion.correctAnswer)
	}
}




