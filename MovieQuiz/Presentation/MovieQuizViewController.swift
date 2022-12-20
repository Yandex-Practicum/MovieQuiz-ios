import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
  
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var textLabel: UILabel!
  @IBOutlet private weak var counterLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Properties
  private var currentQuestion: QuizQuestion?
  private let questionsAmount: Int = 10
  private var currentQuestionIndex: Int = 0
  private var correctAnswers: Int = 0
  
  private var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader())
  private var alertPresenter: AlertPresenter = AlertPresenter()
  private var statisticService: StatisticService = StatisticServiceImplementation()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.layer.cornerRadius = 20
    
    questionFactory.delegate = self
    alertPresenter.delegate = self
    
    textLabel.font = UIFont.ysDisplayBold.withSize(23)
    counterLabel.font = UIFont.ysDisplayMedium
    questionLabel.font = UIFont.ysDisplayMedium
    yesButton.titleLabel?.font = UIFont.ysDisplayMedium
    noButton.titleLabel?.font = UIFont.ysDisplayMedium

    questionFactory.loadData()
    showLoadingIndicator()
  }
  
  // MARK: - Actions
  @IBAction private func noButtonClicked(_ sender: UIButton) {
    guard let currentQuestion = currentQuestion else {
      return
    }
    let isCorrect = currentQuestion.correctAnswer == false
    showAnswerResult(isCorrect: isCorrect)
  }
  
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
    guard let currentQuestion = currentQuestion else {
      return
    }
    let isCorrect = currentQuestion.correctAnswer == true
    showAnswerResult(isCorrect: isCorrect)
  }
  
  // MARK: - Private functions
  private func show(quiz step: QuizStepViewModel) {
    imageView.layer.borderWidth = 0
    imageView.image = step.image
    textLabel.text = step.question
    counterLabel.text = step.questionNumber
  }
  
  private func show(quiz result: QuizResultsViewModel) {
    
    let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] _ in
      guard let self = self else { return }
      
      self.currentQuestionIndex = 0
      self.correctAnswers = 0
      self.questionFactory.requestNextQuestion()
    }
    
    alertPresenter.show(alertModel: alertModel)
  }
  
  private func showNextQuestionOrResults() {
    if currentQuestionIndex == questionsAmount - 1 {
      statisticService.store(correct: correctAnswers, total: questionsAmount)
      let text = """
      Ваш результат: \(correctAnswers)/10
      Количество сыгранных квизов: \(statisticService.gamesCount)
      Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
      Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
      """

      let viewModel = QuizResultsViewModel(
        title: "Этот раунд окончен!",
        text: text,
        buttonText: "Сыграть ещё раз")
      show(quiz: viewModel)
    } else {
      currentQuestionIndex += 1
      questionFactory.requestNextQuestion()
    }
    setButtonsAvailability(true)
  }
  
  private func showAnswerResult(isCorrect: Bool) {
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    
    if isCorrect {
      correctAnswers += 1
    }
    setButtonsAvailability(false)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
      guard let self = self else { return }
      self.showNextQuestionOrResults()
    }
  }
   
  private func showLoadingIndicator() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
  }
  
  private func showNetworkError(message: String) {
    hideLoadingIndicator()
    let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз")
    alertPresenter.show(alertModel: model)
  }
  
  private func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
      image: UIImage(data: model.image) ?? UIImage(),
      question: model.text,
      questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
    )
  }
  
  private func setButtonsAvailability(_ value: Bool) {
    yesButton.isEnabled = value
    noButton.isEnabled = value
  }
  
  private func hideLoadingIndicator() {
    activityIndicator.isHidden = true
  }
  
  // MARK: - QuestionFactoryDelegate
  func didRecieveNextQuestion(question: QuizQuestion?) {
    guard let question = question else {
      return
    }
    
    currentQuestion = question
    let viewModel = convert(model: question)
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.show(quiz: viewModel)
    }
  }
  
  func didFailToLoadData(with error: Error) {
    showNetworkError(message: error.localizedDescription)
  }
  
  func didLoadDataFromServer() {
    activityIndicator.isHidden = true
    questionFactory.requestNextQuestion()
  }
  
  // MARK: - AlertPresenterDelegate
  func presentQuizResults(_ alert: UIAlertController) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.present(alert, animated: true, completion: nil)
    }
  }
  
}
