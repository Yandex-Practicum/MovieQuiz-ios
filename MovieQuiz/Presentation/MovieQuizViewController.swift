import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var mainQuestionLabel: UILabel!
    
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    let questionsAmount: Int = 10
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    var alertPresenter: ResultAlertPresenter?
    var statisticService: StatisticService?
    var moviesLoader: MoviesLoading = MoviesLoader()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader)
        alertPresenter = ResultAlertPresenter(delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        statisticService = StatisticServiceImplementation()
    }
    
    @IBOutlet weak var yesButtonView: UIButton!
    
    @IBOutlet weak var noButtonView: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        yesButtonView.isEnabled = false
        isAnswerCorrect(true)
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        noButtonView.isEnabled = false
        isAnswerCorrect(false)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func didLoadDataFromServer() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
        }
        questionFactory?.requestNewQuestions()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    //Показ ошибки
    private func showNetworkError(message: String) {
        let downloadError = QuizResultsViewModel(
            title: "Что-то пошло не так",
            text: "Невозможно загрузить данные",
            buttonText: "Попробовать ещё раз")
        DispatchQueue.main.async {
            self.show(quiz: downloadError)
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        mainQuestionLabel.text = step.question
        counterLabel.text = "\(currentQuestionIndex+1)/10"
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        alertPresenter?.show(quiz: result)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.gamesCount += 1
            statisticService?.correct += correctAnswers
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let averageAccuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0)
            
            let text = "Ваш результат: \(correctAnswers)/10 \n Кол-во сыгранных игр: \(statisticService?.gamesCount ?? 0) \n Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date ?? "")) \n Средняя точность: \(averageAccuracy)%"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNewQuestions()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.yesButtonView.isEnabled = true
            self.noButtonView.isEnabled = true
        }
    }
    
    private func isAnswerCorrect(_ userAnswer: Bool) {
        guard let currentUnwrapped = currentQuestion else { return }
        let isCorrect = currentUnwrapped.correctAnswer == userAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
}
