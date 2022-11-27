import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate  {
        
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    @IBOutlet private weak var buttonNo: UIButton!
    @IBOutlet private weak var buttonYes: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        buttonNo.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        //showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        buttonYes.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        //showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(delegate: self)
        
        questionFactory?.loadData()
        showLoadingIndicator()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print(NSHomeDirectory())
//        print(Bundle.main.bundlePath)
//
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//
//        alertPresenter = AlertPresenter(delegate: self)
//        imageView.layer.cornerRadius = 20
//        questionFactory = QuestionFactory(delegate: self)
//        questionFactory?.requestNextQuestion()
//    }
    
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
    
    // MARK: - AlertPresenterDelegate
    
    func didShowAlert(controller: UIAlertController?) {
        guard let controller = controller else {
            return
        }
        present(controller, animated: true, completion: nil)

    }

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
         return QuizStepViewModel(
             image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
             question: model.text, // берём текст вопроса
             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
     }
    
//    private func showAnswerResult(isCorrect: Bool) {
//        if isCorrect {
//            correctAnswers += 1
//        }
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        //imageView.layer.cornerRadius = 20
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//            self.buttonNo.isEnabled = true
//            self.buttonYes.isEnabled = true
//            self.showNextQuestionOrResults()
//        }
//    }
    
    private func showAnswerResult(isCorrect: Bool) {
          if isCorrect {
              correctAnswers += 1
          }

          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = 8
          imageView.layer.cornerRadius = 20
          imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
          self.buttonYes.isEnabled = false
          self.buttonNo.isEnabled = false

          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
              guard let self = self else {return}
              // запускаем задачу через 1 секунду
              self.buttonYes.isEnabled = true
              self.buttonNo.isEnabled = true
              self.imageView.layer.borderWidth = 0
              self.showNextQuestionOrResults()

          }

      }
    
    private func showNextQuestionOrResults() {

        if currentQuestionIndex == questionsAmount - 1 {

            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)\nКоличество сыграных квизов: \(statisticService.gamesCount)\nРекорд:  \(statisticService.bestGame.correct)/\(questionsAmount) \(statisticService.bestGame.date)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy as CVarArg))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel) // show result
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }

    }


    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber

    }

    private func show(quiz result: QuizResultsViewModel) {

        let model = AlertModel(title: result.title,
                               message: result.text,
                               buttonText: result.buttonText) {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(model: model)

    }
    
    // MARK: Индикатор загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
         activityIndicator.isHidden = true
         activityIndicator.stopAnimating()
     }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(title: "Network Error",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            self.showLoadingIndicator()
            self.questionFactory?.loadData()

        }
        alertPresenter?.showAlert(model: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
}
