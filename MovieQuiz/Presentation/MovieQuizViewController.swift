// my project
// swiftlint: disable all

import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionNumber: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    // MARK: - Properties
    // private let questions: [QuizQuestion] = mockQuestions
    private var currentQuestionIndex: Int = 0
    private var gamesScore: QuizScores = QuizScores()
    private var questionsAmount: Int = 10
    private let questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20

      //  if let firstQuestion = questionFactory.requestNextQuestion() {
      //       currentQuestion = firstQuestion
      //      let viewModel = convert(model: firstQuestion)
      //      showQuestion() */

        questionFactory.requestNextQuestion { [weak self] question in
            guard
                let self = self,
                let question = question
            else {
                // Ошибка
                return
            }
            self.currentQuestion = question
            let viewModel = self.convert(model: question)
            DispatchQueue.main.async {
                self.showQuestion()
            }

        }
    }
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(answer: false)
        /* question: questions[currentQuestionIndex]) */
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(answer: true)
        /* question: questions[currentQuestionIndex]) */
    }

    // MARK: - Logic

    private func showQuestion() {
        /// Установили текущий вопрос. Так как у нас квиз начинается с 1го вопроса,
        /// то и берем из массива вопросов 1й элемент
        currentQuestion = QuestionFactory.questions[safe: currentQuestionIndex] // метод лежит в Array+Extensions
        guard let currentQuestion = currentQuestion else {
            return
        }

        let questionViewModel = convert(model: currentQuestion)
        show(quiz: questionViewModel)

    }

    private func show(quiz step: QuizStepViewModel) { // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        questionLabel.text = step.question
        questionNumber.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
        showResultAlert(result: result)
    }

    private func correctAnswerCounter() {
        gamesScore.score += 1
    }


    private func showAnswerResult(answer: Bool) {

        guard let currentQuestion = currentQuestion
        else {
            return
        }

        let isCorrect = (answer == currentQuestion.correctAnswer)
        let greenColor = UIColor(named: "green") ?? .green
        let redColor = UIColor(named: "red") ?? .red
        let borderColor = isCorrect ? greenColor : redColor

    if answer == currentQuestion.correctAnswer {
        gamesScore.score += 1
    } else {}

        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = borderColor.cgColor // делаем рамку зеленой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки

        buttonsEnabled(is: false) // временно отключаем кнопки до появления следующего вопроса
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.buttonsEnabled(is: true) //включаем кнопки, когда появляется следующий вопрос
        }
    }




    private func buttonsEnabled(is state: Bool) { //определяем состояние кнопок
        if state {
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        } else {
            self.yesButton.isEnabled = false
            self.noButton.isEnabled = false
        }
    }


    private func showNextQuestionOrResults() {
        if currentQuestionIndex == QuestionFactory.questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            print("Пора показать результат")
            gamesScore.itIsRecord() // проверяем рекорд ли это
            if gamesScore.score == 10 {
                let winResult = QuizResultsViewModel (
                    title: "Вы выиграли!",
                    text:  """
                    Ваш результат: \(gamesScore.score)/\(QuestionFactory.questions.count)
                    Количество сыгранных квизов: \(gamesScore.gamesPlayed)
                    Рекорд: \(gamesScore.record)/\(QuestionFactory.questions.count) (\(gamesScore.recordTime))
                    Средняя точность: \(gamesScore.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: winResult)
            } else {
                let result = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text:
                    """
                    Ваш результат: \(gamesScore.score)/\(QuestionFactory.questions.count)
                    Количество сыгранных квизов: \(gamesScore.gamesPlayed)
                    Рекорд: \(gamesScore.record)/\(QuestionFactory.questions.count) (\(gamesScore.recordTime))
                    Средняя точность: \(gamesScore.accuracyAverage())%
                    """,
                    buttonText: "Сыграть еще раз"
                )
                show(quiz: result)
            }
                
            // создаём объекты всплывающего окна
            // показать результат квиза

        } else {
            currentQuestionIndex += 1
            // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            showQuestion()
            // показать следующий вопрос
        }
    }

    private func restart() {
        currentQuestionIndex = 0 // Сбросил вопрос на первый
        gamesScore.restartQuiz()
        showQuestion()
    }



    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }


    // Выносим показ окна алерта в отдельную функцию
    private func showResultAlert (result: QuizResultsViewModel) {
            let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                          message: result.text, /* текст во всплывающем окне */
                                          preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

            // создаём для него кнопки с действиями
            let action = UIAlertAction(title: "Сыграть ещё раз",
                                       style: .default, handler: { _ in
              print("Игра началась заново")
                self.restart() // заново запускаем квиз с номера 1
            })

            // добавляем в алерт кнопки
            alert.addAction(action)

            // показываем всплывающее окно
            self.present(alert, animated: true, completion: nil)
        }






}
