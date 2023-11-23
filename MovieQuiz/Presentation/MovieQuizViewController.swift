import UIKit
// MARK: -

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Private Properties
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactory?
    private var alertPresenter: AlertPresenter?
    private lazy var statisticService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(view: self)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    // MARK: - QuestionFactoryDelegate.
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
    
    func didLoadDataFromServer () {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error){
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - PrivateFunc
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            questions: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.questions
        counterLabel.text = step.questionNumber
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
            
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.enableButtons()
        }
    }
    private func showAlert(quizResult quiz: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: quiz.title,
                                    message: quiz.text,
                                    buttonText: quiz.buttonText,
                                    buttonAction: {[weak self] in
            self?.currentQuestionIndex = 0
            self?.correctAnswer = 0
            self?.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.show(data: alertModel)
    }
    
    
    private func disableButtons (){
        yesButtonOutlet.isEnabled = false
        noButtonOutlet.isEnabled = false
    }
    private func enableButtons (){
        yesButtonOutlet.isEnabled = true
        noButtonOutlet.isEnabled = true
    }
    private func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            
            self.questionFactory?.loadData()
        }
        alertPresenter?.show(data: model)
    }
    private func showNextQuestionOrResults(){
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswer, total: questionsAmount)
            
            showAlert (quizResult: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                           Ваш результат: \(correctAnswer)/10
                           Количество сыгранных квизов: \(statisticService.gamesCount)
                           Рекорд: \(statisticService.bestGame.toString()))
                           Средняя точность: \(Int(statisticService.totalAccuracy))%
                           """,
                buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    // MARK: - Actions
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
    // MARK: - IBOutlet
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
}
