import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

struct QuizQuestion {
    //строка с названием фильма
    //свпадает с названием картинки афиши фильма в Assets
    var image: String
    
    //строка с названием вопроса о фильме
    var text: String
    
    //будевое значение (true, false), дающее правильный ответ на вопрос
    var correctAnswer: Bool
}

var theGodfather: QuizQuestion = QuizQuestion(image: "The theGodFather", text: "Рейтин этого фильма больше чем 6?", correctAnswer: true)

var theDarkKnight: QuizQuestion = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theAvengers = QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)

var theIceAgeAdvanturesOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

private let questions: [QuizQuestion] = [theGodfather, theDarkKnight, killBill, theAvengers, deadpool, theGreenKnight, old, theIceAgeAdvanturesOfBuckWild, tesla, vivarium]


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
