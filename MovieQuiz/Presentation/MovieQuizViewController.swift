import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var playedQuizCauntity = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenterProtocol: AlertPresenterProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticsService: StatisticService?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenterProtocol = AlertPresenter(viewController: self)
        statisticsService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func show(quizStepViewModel: QuizStepViewModel,  nextQuestion: QuizQuestion) {
        imageView.image = quizStepViewModel.image
        textLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
        currentQuestion = nextQuestion
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return quizStepViewModel
    }
    
    private func showLoadingIndicator() {
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStepViewModel: viewModel, nextQuestion: question)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert : AlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.loadData()
                
            }
        alertPresenterProtocol?.showAlert(alertModel: alert)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if(isCorrect){
            imageBorder(
                borderColor: YPColors.green
            )
        }else{
            imageBorder(
                borderColor: YPColors.red
            )
        }
        if isCorrect {
            correctAnswers += 1
        }
        if currentQuestionIndex == questionsAmount - 1{
            playedQuizCauntity += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageBorder(
                borderColor: YPColors.black
            )
        }
    }
    
    private func imageBorder(borderColor: CGColor){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor
        imageView.layer.cornerRadius = 20
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            finalResult()
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func finalResult(){
        statisticsService?.store(correct: correctAnswers, total: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз",
            completion: {[weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenterProtocol?.showAlert(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String{
        
        guard let statisticsService = statisticsService, let bestGame = statisticsService.bestGame else {
            return ""
        }
        let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let playedQuizCauntity = "Количество сыгранных квизов: \(statisticsService.gamesCount)"
        let accuracy = "Средняя точность: \(String(format: "%2.f", statisticsService.totalAccuracy))%"
        let bestResult = "Рекорд: \(bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))"
        let result = [ text, playedQuizCauntity, bestResult, accuracy].joined(separator: "\n")
        return result
    }
    
    @IBAction private func noButtonClick(_ sender: Any) {
        let answer = false
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    @IBAction private func yesButtonClick(_ sender: Any) {
        let answer = true
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
}
