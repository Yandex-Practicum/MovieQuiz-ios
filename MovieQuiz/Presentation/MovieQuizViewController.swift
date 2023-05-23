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

  //  private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol? = nil
    var alertPresenter: AlertPresenter?
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

//шаг 6
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        let action = UIAlertAction(title: "Попробовать ещё раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.presenter.resetQuestionIndex()
            self.presenter.restartGame()
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(model)
        
    }

   func didReceiveNextQuestion(question: QuizQuestion?) {
       presenter.didReceiveNextQuestion(question: question)
    }

     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0 // толщина рамки

         //шаг 6
         if let statisticService = statisticService {
             statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)

             let currentGameResultLine = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)"
         }
         //шаг 6
         let action = UIAlertAction(title: result.buttonText, style: .default) [weak self] _ in
         self.presenter.restartGame

    }

    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3

        view.isUserInteractionEnabled = false // выключает интерактивность

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true  // включаем интерактивность
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }


    private func showNextQuestionOrResults() {
           if presenter.isLastQuestion() {
               // идём в состояние "Результат квиза"
               guard let statisticService = statisticService else {
                   return
               }

               statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)

               let text = "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте ещё раз!"


               let viewModel = AlertModel (
                   title: "Этот раунд окончен!",
                   message: text,
                   buttonText: "Сыграть ещё раз") { [weak self] _ in

                       guard let self = self else { return }
                       self.presenter.resetQuestionIndex()
                       //сбрасываем переменную с количеством правильных ответов
                       self.presenter.correctAnswers = 0
                       self.questionFactory?.requestNextQuestion()
                   }
               alertPresenter?.show(viewModel)

           } else {
               presenter.switchToNextQuestion()
               questionFactory?.requestNextQuestion()
           }
       }

}

