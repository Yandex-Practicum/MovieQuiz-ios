import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceImplementation?
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory?.requestNextQuestion()
        
       
        showLoadingIndicator()
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter(viewController: self)
        imageView.contentMode = .scaleAspectFill
        
            }
    //MARK: QuestionFactoryDalagate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        } }
    @IBAction private func yesButtonClick(_ sender: Any) {
        noButton.isEnabled = false
        yesBotton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClick(_ sender: Any) {
        noButton.isEnabled = false
        yesBotton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesBotton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            
            self.imageView.layer.masksToBounds = false
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
            self.noButton.isEnabled = true
            self.yesBotton.isEnabled = true
            self.showNextQuestionOrResults()
        }
    }
    
    // вью модель для состояния "Вопрос показан"
    
    // для состояния "Результат квиза"
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")

    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        textLabel.textAlignment = .center
    }
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService = StatisticServiceImplementation()
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let stat = statisticService?.totalAccuracy,
                  let dateRecord = statisticService?.bestGame.date,
                  let bestGame = statisticService?.bestGame else {
                assertionFailure("error")
                return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy HH:mm:ss"
            let dateRecordString = dateFormatter.string(from: dateRecord)
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат \(correctAnswers)/10 \nКоличество сыгранных квизов: \(String(statisticService?.gamesCount ?? 0)) \nРекорд: \(bestGame.correct)/\(10) (\(dateRecordString)) \nСредняя точность: \(String(format: "%.2f", stat))%",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else { // 2
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() } }
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title,
                                    message: result.text,
                                    buttonText: result.buttonText,
                                    comletion: { [ weak self ] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
            
            
        })
        alertPresenter?.show(with: alertModel )
        
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
            
            
        }
        
        alertPresenter?.show(with: model) }
}


// массив вопросов
