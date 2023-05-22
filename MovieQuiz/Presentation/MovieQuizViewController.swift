import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - Аутлеты и действия
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    //MARK: - Свойства
    // переменная с индексом текущего вопроса, начальное значение 0
    // (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)

    // переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol? = nil
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()


    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()

        //рамка
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 0 // толщина рамки
        imageView.layer.borderColor = UIColor.ypWhite.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplemintation()
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(delegate: self)
        presenter.viewController = self
        
    }

    // MARK: - Логика

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // индикатор скрыт
        activityIndicator.stopAnimating() // выключаем анимацию
    }

    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описания ошибки
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(model)
        
    }

   func didReceiveNextQuestion(question: QuizQuestion?) {
       presenter.didReceiveNextQuestion(question: question)
    }

    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
     func show(quiz step: QuizStepViewModel) {
        // попробуйте написать код показа на экран самостоятельно
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        // imageView.layer.borderColor = UIColor.ypWhite.cgColor // цвет рамки
        imageView.layer.borderWidth = 0 // толщина рамки
    }

    func showAnswerResult(isCorrect: Bool) {

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
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            // идём в состояние "Результат квиза"
            guard let statisticService = statisticService else {
                return
            }

            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)

            let text = """
                       Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                       Количество сыгранных квизов: \(statisticService.gamesCount)
                       Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                       Cредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                       """
            
            let viewModel = AlertModel (
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") { [weak self] _ in

                    guard let self = self else { return }
                    self.presenter.resetQuestionIndex()
                    //сбрасываем переменную с количеством правильных ответов
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            alertPresenter?.show(viewModel)

        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}

