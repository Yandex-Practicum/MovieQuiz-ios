import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

// MARK: - Аутлеты и действия
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
         let givenAnswer = true
         showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
           let givenAnswer = false
           showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

//MARK: - Свойства
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0

    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = nil
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?


// MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()

        //рамка
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.borderColor = UIColor.ypWhite.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplemintation()
    }

// MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

// MARK: - Логика

// метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
private func convert(model: QuizQuestion) -> QuizStepViewModel {
    // Создаем QuizStepViewModel из свойств модели QuizQuestion
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    self.view.isUserInteractionEnabled = true  // включаем интерактивность
                    self.showNextQuestionOrResults()
                }


    }

    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
          // идём в состояние "Результат квиза"
            guard let statisticService = statisticService else {
                return
            }

            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let text = """
                       Ваш результат: \(correctAnswers)/\(questionsAmount)
                       Количество сыгранных квизов: \(statisticService.gamesCount)
                       Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                       Cредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                       """
            /* переделать так, чтоб содержала данные из гейм рекорд */
            let viewModel = AlertModel (
                       title: "Этот раунд окончен!",
                       message: text,
                       buttonText: "Сыграть ещё раз") { [weak self] _ in
                           
                           guard let self = self else { return }
                           self.currentQuestionIndex = 0
                           //сбрасываем переменную с количеством правильных ответов
                           self.correctAnswers = 0
                           self.questionFactory?.requestNextQuestion()
                       }
            alertPresenter?.show(viewModel)

        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
} //КОНЕЦ КЛАССА MovieQuizViewController

