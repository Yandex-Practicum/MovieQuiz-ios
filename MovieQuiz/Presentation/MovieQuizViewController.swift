import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    @IBAction private func yesButtonClicked(_ sender: UIButton) {

    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {

    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    struct QuizQuestion {
        let imageName: String
        let questionText: String
        let correctAnswer: Bool
        var questionNumber = 0

        private let questions = [
            QuizQuestion(imageName: "The Godfather", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "The Dark Knight", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "Kill Bill", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "The Avengers", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "The Avengers", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "The Green Knight", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(imageName: "Old", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(imageName: "The Ice Age Adventures of Buck Wild", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(imageName: "Tesla", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(imageName: "Vivarium", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        ]
    }
    //
    //
    //    Картинка: Old
    //        Настоящий рейтинг: 5,8
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: НЕТ
    //
    //
    //    Картинка: The Ice Age Adventures of Buck Wild
    //        Настоящий рейтинг: 4,3
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: НЕТ
    //
    //
    //    Картинка: Tesla
    //        Настоящий рейтинг: 5,1
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: НЕТ
    //
    //
    //    Картинка: Vivarium
    //        Настоящий рейтинг: 5,8
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: НЕТ
    //
    //
    //
    //    Картинка: The Godfather
    //        Настоящий рейтинг: 9,2
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА
    //
    //
    //    Картинка: The Dark Knight
    //        Настоящий рейтинг: 9
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА
    //
    //
    //    Картинка: Kill Bill
    //        Настоящий рейтинг: 8,1
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА
    //
    //
    //    Картинка: The Avengers
    //        Настоящий рейтинг: 8
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА
    //
    //
    //
    //    Картинка: Deadpool
    //        Настоящий рейтинг: 8
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА
    //
    //
    //    Картинка: The Green Knight
    //        Настоящий рейтинг: 6,6
    //    Вопрос: Рейтинг этого фильма больше чем 6?
    //    Ответ: ДА


}
