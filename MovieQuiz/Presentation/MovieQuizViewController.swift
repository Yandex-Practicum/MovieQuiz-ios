import UIKit

final class MovieQuizViewController: UIViewController {





    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        struct QuizQuestion {
            let imageName: String
            let questionText: String
            let correctAnswer: Bool
        }


        let questions1 = QuizQuestion (
            imageName: "The Godfather", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions2 = QuizQuestion (
            imageName: "The Dark Knight", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions3 = QuizQuestion (
            imageName: "Kill Bill", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions4 = QuizQuestion (
            imageName: "The Avengers", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions5 = QuizQuestion (
            imageName: "Deadpool", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions6 = QuizQuestion (
            imageName: "The Green Knight", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: true
        )

        let questions7 = QuizQuestion (
            imageName: "Old", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false
        )

        let questions8 = QuizQuestion (
            imageName: "The Ice Age Adventures of Buck Wild", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false
        )

        let questions9 = QuizQuestion (
            imageName: "Tesla", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false
        )

        let questions10 = QuizQuestion (
            imageName: "Vivarium", questionText: "Рейтинг этого фильма больше чем 6?", correctAnswer: false
        )

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



