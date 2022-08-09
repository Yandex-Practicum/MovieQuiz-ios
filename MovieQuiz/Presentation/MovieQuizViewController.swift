import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard qNumber < questions.count else { return }
        if !questions[qNumber].correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard qNumber < questions.count else { return }
        if questions[qNumber].correctAnswer {
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
        let title: String
        var text: String
    }

    private var questions: [QuizeQuestion] = []
    private var qNumber: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel: QuizeStepViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: 0)
    private var resultsViewModel: QuizeResultsViewModel = QuizeResultsViewModel(title: "Этот раунд окончен!", text: "")
    private var accuracy: [Float] = []
    private var avgAccuracy: Float = 0.0

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(image: model.image, question: model.text, questionNumber: qNumber)
    }

    private func show(quize step: QuizeStepViewModel) {
        let currentViewModel = convert(model: questions[qNumber])
        imageView.image = UIImage(named: currentViewModel.image)
        textLabel.text = currentViewModel.question
        counterLabel.text = "\(currentViewModel.questionNumber + 1)/\(questions.count)"
    }

    private func show(quize result: QuizeResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                    message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "Сыграть еще раз!", style: .default, handler: { _ in
            self.corrects = 0
            self.wrongs = 0
            self.qNumber = 0
            self.show(quize: self.convert(model: self.questions[self.qNumber]))
        })

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        if isCorrect {
            imageView.layer.borderColor = UIColor.green.cgColor
            corrects += 1
        }
        else {
            imageView.layer.borderColor = UIColor.red.cgColor
            wrongs += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        qNumber += 1
        guard qNumber < questions.count else {
            rounds += 1
            if corrects > records {
                records = corrects
                let dt = Date()
                recordDate = dt.dateTimeString
            }
            if corrects > 0 {
                accuracy.append(Float(questions.count / corrects) * 100.0)
            }
            else {
                accuracy.append(0.0)
            }
            if !accuracy.isEmpty {
                var sumArray: Float {
                    return accuracy.reduce(0 as Float) { $0 + Float($1) }
                }
                avgAccuracy = sumArray / Float(accuracy.count)
            }
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questions.count)\nКоличество сыграных квизов:\(rounds)\nРекорд: \(records)/\(questions.count) (\(recordDate)"
            resultsViewModel.text += "\nСредняя точность: \(avgAccuracy)%"
            show(quize: resultsViewModel)
            return
        }
        show(quize: convert(model: questions[qNumber]))
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        questions.append(QuizeQuestion(image: "The Godfather",text: "Рейтинг этого фильма больше, чем 6?",correctAnswer: true))
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
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
        show(quize: convert(model: questions[qNumber]))
    }
}
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
