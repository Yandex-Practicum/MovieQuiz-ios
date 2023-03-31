import UIKit

final class MovieQuizViewController: UIViewController {

// MARK: - Аутлеты и действия
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!

    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
         let givenAnswer = true
         showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
           let givenAnswer = false
           showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

// MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()

        //рамка
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.borderColor = UIColor.ypWhite.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки

        // берём текущий вопрос из массива вопросов по индексу текущего вопроса
        let currentQuestion = questions[currentQuestionIndex]
        let quizStep = convert(model: currentQuestion)
        show(quiz: quizStep)
    }

// переменная с индексом текущего вопроса, начальное значение 0
// (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
private var currentQuestionIndex = 0

// переменная со счётчиком правильных ответов, начальное значение закономерно 0
private var correctAnswers = 0

// массив вопросов
private let questions: [QuizQuestion] = [
    QuizQuestion (
        image: "The Godfather",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "The Dark Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "Kill Bill",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "The Avengers",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "Deadpool",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "The Green Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion (
        image: "Old",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion (
        image: "The Ice Age Adventures of Buck Wild",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion (
        image: "Tesla",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion (
        image: "Vivarium",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false)]

// MARK: - Логика

// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
private func convert(model: QuizQuestion) -> QuizStepViewModel {
    // Создаем QuizStepViewModel из свойств модели QuizQuestion
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    return questionStep
}

// приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
private func show(quiz step: QuizStepViewModel) {
  // попробуйте написать код показа на экран самостоятельно
    imageView.image = step.image
    questionLabel.text = step.question
    counterLabel.text = step.questionNumber
   // imageView.layer.borderColor = UIColor.ypWhite.cgColor // цвет рамки
    imageView.layer.borderWidth = 0 // толщина рамки
}

    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {

        if isCorrect {
            correctAnswers += 1
        }

       // метод красит рамку
        //Даём разрешение на рисование рамки
        imageView.layer.masksToBounds = true
        //Указываем толщину рамки согласно по макету
        imageView.layer.borderWidth = 8
        //С помощью тернарного условного оператора красим рамку в нужный цвет в зависимости от ответа пользователя. Аналогично мы могли бы написать ту же логику через условный оператор if else.
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3


        view.isUserInteractionEnabled = false // выключает интерактивность
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.view.isUserInteractionEnabled = true  // включаем интерактивность
                    self.showNextQuestionOrResults()
                }


    }

    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
          // идём в состояние "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                       title: "Этот раунд окончен!",
                       text: text,
                       buttonText: "Сыграть ещё раз")
                   show(quiz: viewModel) 

        } else {
            currentQuestionIndex += 1

            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)

            show(quiz: viewModel)
        }
    }

// MARK: - Alert
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title, //заголовок алерта
            message: result.text, //текст в сплывающем окне
            preferredStyle: .alert) //preferedStyle может быть .alert или .actionSheet

        //в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0

            //сбрасываем переменную с количеством правильных ответов
            self.correctAnswers = 0

            //заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel) //код, который сбрасывает игру и показывает первый вопрос
        }

        //добавляем в алерт кнопку
        alert.addAction(action)

        //показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

} //КОНЕЦ КЛАССА


// MARK: - Структуры и переменные

struct QuizQuestion {
  // строка с названием фильма, совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}
