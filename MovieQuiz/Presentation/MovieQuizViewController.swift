import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    // переменная с индексом текущего вопроса, начальное значение 0
    private var correctAnswers = 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var currentQuestionIndex = 0
    //массив вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather"
                     , text: "Рейтинг этого фильма больше чем 6?"
                     , corrcetAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     corrcetAnswer: false)
    ]
    
    // константа с кнопкой для системного алерта
  
    override func viewDidLoad() {
        show(quiz: convert(model: questions[currentQuestionIndex]))
        super.viewDidLoad()
    }
    // метод вызывается, когда пользователь нажимает на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        //        if questions[currentQuestionIndex].corrcetAnswer == false {
        //            showAnswerResult(isCorrect: true)
        //            correctAnswers += 1
        //        } else {
        //            showAnswerResult(isCorrect: false)
        //        }
        //
        //        if currentQuestionIndex+1 < questions.count {
        //            currentQuestionIndex += 1
        //        } else {
        //            currentQuestionIndex = 0
        //            correctAnswers = 0
        //        }
        //        show(quiz: convert(model: questions[currentQuestionIndex]))
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.corrcetAnswer)
        
    }
    // метод вызывается, когда пользователь нажимает на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        //        if questions[currentQuestionIndex].corrcetAnswer == true {
        //            showAnswerResult(isCorrect: true)
        //            correctAnswers += 1
        //        } else {
        //            showAnswerResult(isCorrect: false)
        //        }
        //
        //        if currentQuestionIndex+1 < questions.count {
        //            currentQuestionIndex += 1
        //        } else {
        //            currentQuestionIndex = 0
        //            correctAnswers = 0
        //        }
        //        show(quiz: convert(model: questions[currentQuestionIndex]))
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.corrcetAnswer)
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert (model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ??  UIImage(),
            question: model.text,
            questionNumber:"\(currentQuestionIndex+1)/\(questions.count)")
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: (result.title),
            message: (result.text),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            // код, который сбрасывает игру и показывает первый вопрос
            self.currentQuestionIndex = 0 // 1
            
            let firstQuestion = self.questions[self.currentQuestionIndex] // 2
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // 1
               correctAnswers += 1 // 2
           }
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 1 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor//
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
}

struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let corrcetAnswer: Bool
}

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
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
}

/*
 Mock-данные
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
