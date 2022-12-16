import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let presenter = MovieQuizPresenter()
    
    private var correctAnswers: Int = 0
   
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService!

    //MARK: - View Did Loade
    
    override func viewDidLoad(){

        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(viewController: self)
        activityIndicator.startAnimating()
        questionFactory?.loadData()
    }
    
    //MARK: - Internal functions
    
   func didLoadDateFromServer() {
       activityIndicator.stopAnimating()
       questionFactory?.requestNextQuestion()
    }
    
   func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // Берем в качестве сообщения описание ошибки
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private functions
    
    
    var vSpinner : [UIView] = []

    private func loadingIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        self.view.addSubview(activityIndicator)
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        let networkError = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else {return}
            self.restartGame()
            self.questionFactory?.loadData()
            
        }
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.showAlert(quiz: networkError)
    }
    
    private func restartGame() {
        self.presenter.resetQuestionIndex()
        self.questionFactory?.requestNextQuestion()
        self.correctAnswers = 0
        self.activityIndicator.startAnimating()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            if isCorrect { correctAnswers += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
        }
    }
    
    private func show(quiz step: QuizStepViewModel){
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showNextQuestionOrResults(){
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            guard let bestGame = statisticService?.bestGame else {return}
            let text = """
                       Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)
                       Количество сыгранных квизов: \(statisticService.gamesCount)
                       Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(bestGame.date.dateTimeString))
                       Средняя точность: \(Int(statisticService.totalAccuracy))%
                       """
            let viewModel = QuizResultsViewModel(
                            title: "Этот раунд окончен!",
                            text: text,
                            buttonText: "Сыграть еще раз")
                        
            self.correctAnswers = 0
            show(quiz: viewModel)
        }else{
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func blockButtons() {
            yesButton.isEnabled = false
            noButton.isEnabled = false
            activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
                self.activityIndicator.stopAnimating()
        }
    }
        
    private func show(quiz result: QuizResultsViewModel) {
                let alertModel = AlertModel(
                    title: result.title,
                    message: result.text,
                    buttonText: result.buttonText)
                    { [weak self] _ in
                        guard let self = self else { return }
                        self.restartGame()
                }
                alertPresenter?.showAlert(quiz: alertModel)
            }
        
        
        
    
        
        // MARK: - Action button
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            blockButtons()
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            blockButtons()
        }
    }
