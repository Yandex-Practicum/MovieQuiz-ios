import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard questionNumberGlobal < questions.count else { return }
        if !questions[questionNumberGlobal].correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard questionNumberGlobal < questions.count else { return }
        if questions[questionNumberGlobal].correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }

    struct QuizeQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizeStepViewModel {
        let image: String
        let question: String
        let questionNumber: Int
    }

    struct QuizeResultsViewModel {
        var title: String
        var text: String
    }

    private var questions: [QuizeQuestion] = []
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel: QuizeStepViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: 0)
    private var resultsViewModel: QuizeResultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy: Double = 0.0
    private var buttonsBlocked: Bool = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(image: model.image, question: model.text, questionNumber: questionNumberGlobal)
    }

    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        let currentViewModel = convert(model: questions[questionNumberGlobal])
        moviePoster.image = UIImage(named: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = "\(currentViewModel.questionNumber + 1)/\(questions.count)"
        //buttonsBlocked = false
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func show(quize result: QuizeResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                    message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "Сыграть еще раз!", style: .default, handler: { _ in
            self.show(quize: self.convert(model: self.questions[self.questionNumberGlobal]))
        })

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moviePoster.layer.borderWidth = 8
        if isCorrect {
            moviePoster.layer.borderColor = greenColor
            corrects += 1
        }
        else {
            moviePoster.layer.borderColor = redColor
            wrongs += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        questionNumberGlobal += 1
        guard questionNumberGlobal < questions.count else {
            rounds += 1
            if corrects > records {
                records = corrects
                let temporaryDateVar = Date()
                recordDate = temporaryDateVar.dateTimeString
            }
            if corrects > 0 {
                accuracy.append((Double(corrects) / Double(questions.count)) * 100.0)
            }
            else {
                accuracy.append(0.0)
            }
            if !accuracy.isEmpty {
                sumAccuracy = 0.0
                for element in accuracy {
                    sumAccuracy += element
                }
                print(sumAccuracy)
                avgAccuracy = sumAccuracy / Double(accuracy.count)
            }
            if corrects != questions.count {
                resultsViewModel.title = "Этот раунд окончен!"
            }
            else {
                resultsViewModel.title = "Потрясающе!"
            }
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questions.count)\nКоличество сыграных квизов:\(rounds)\nРекорд: \(records)/\(questions.count) (\(recordDate))"
            resultsViewModel.text += "\nСредняя точность: \(avgAccuracy)%"
            corrects = 0
            wrongs = 0
            questionNumberGlobal = 0
            show(quize: resultsViewModel)
            return
        }
        show(quize: convert(model: questions[questionNumberGlobal]))
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        questions.append(QuizeQuestion(image: "The Godfather",text: "Рейтинг этого замечательного фильма \"Крестный отец\" больше, чем 6?" ,correctAnswer: true))
        questions.append(QuizeQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true))
        questions.append(QuizeQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true))
        questions.append(QuizeQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true))
        questions.append(QuizeQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true))
        questions.append(QuizeQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: true))
        questions.append(QuizeQuestion(image: "Old", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false))
        questions.append(QuizeQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false))
        questions.append(QuizeQuestion(image: "Tesla", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false))
        questions.append(QuizeQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше, чем 6?", correctAnswer: false))
        super.viewDidLoad()
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        show(quize: convert(model: questions[questionNumberGlobal]))
    }
}
