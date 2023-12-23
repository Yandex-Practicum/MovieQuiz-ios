import UIKit

final class MovieQuizViewController: UIViewController {
    
    //MARK: - Protocol type variables
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter : AlertPresenterProtocol?
    private var statisticService : StatisticService?
    
    //MARK: - App variables
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var userAnswer = false
    
    //MARK: - Outlets variables
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var noAnswerButton: UIButton!
    @IBOutlet weak var yesAnswerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - System "must be" fucntions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
    //MARK: - Sprint 3-5 Functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
    }
    private func show(quizStepViewModel: QuizStepViewModel) {
        previewImageView.image = quizStepViewModel.image
        questionLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
    }
    private func presentNextQuizStepQuestion(){
        UIView.animate(withDuration: 1){ [weak self] in
            self?.questionFactory?.requestNextQuestion()
            
        }
    }
    private func handleEnableAnswersButtons(){
        noAnswerButton.isEnabled.toggle()
        yesAnswerButton.isEnabled.toggle()
    }
    private func createMessageToShowInAlert() -> String{
        let recordToShow = statisticService?.bestGame
        guard let gamesCount = statisticService?.gamesCount else {return "0"}
        guard let recordCorrectAnswers = recordToShow?.correctAnswers else {return "0"}
        guard let recordTotalQuestions = recordToShow?.totalQuestions else {return "0"}
        guard let accuracy = statisticService?.totalAccuracy else {return "0"}
        guard let date = recordToShow?.date.dateTimeString else {return Date().dateTimeString}
        
        let messageToShow = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количесвто сыгранных квизов: \(gamesCount)
        Рекорд: \(recordCorrectAnswers.description)/\(recordTotalQuestions) (\(date))
        Средняя точность: \(String(format: "%.2f",accuracy))%
        """
        
        return messageToShow
    }
    private func showQuizResults(){
        let messageToShow = createMessageToShowInAlert()
        
        let alertModel = AlertModel(title: "Этот раунд окончен!", text: messageToShow, buttonText: "Сыграть ещё раз",completion: { [weak self] in
            self?.correctAnswers = 0
            self?.currentQuestionIndex = 0
            self?.presentNextQuizStepQuestion()
        })
        self.alertPresenter?.showAlert(alertModel: alertModel)
    }
    private func showAnswerResult(isCorrect: Bool) {
        var color = UIColor(resource: .ypRed).cgColor
        if isCorrect {
            correctAnswers += 1
            color = UIColor(resource: .ypGreen).cgColor
        }
        configureImageFrame(color: color)
        handleEnableAnswersButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.configureImageFrame(color: (UIColor(resource: .ypGray).withAlphaComponent(0)).cgColor)
            self.showNextQuestionOrResults()
            self.handleEnableAnswersButtons()
        }
    }
    private func configureImageFrame(color: CGColor) {
        UIView.animate(withDuration: 0.68) { [weak self] in
            self?.previewImageView.layer.masksToBounds = true
            self?.previewImageView.layer.borderWidth = 8
            self?.previewImageView.layer.cornerRadius = 20
            self?.previewImageView.layer.borderColor = color
        }
    }
    private func showNextQuestionOrResults() {
        self.currentQuestionIndex += 1
        if currentQuestionIndex >= (questionsAmount) {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            showQuizResults()
        } else {
            presentNextQuizStepQuestion()
        }
    }
    
    //MARK: - Sprint 6 Functions
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",text: message,buttonText: "Попробовать еще раз") {
            [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(alertModel: alertModel )
    }
    
    
    
    //MARK: - Storyboard Actions
    
    @IBAction private func yesButtonTapped(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
        
    }
    @IBAction private func noButtonTapped(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizViewController : QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let quizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStepViewModel: quizStepViewModel)
        }
        
        
    }
}

// MARK: - AlertPresenterDelegate

extension MovieQuizViewController : AlertPresenterDelegate {
    
    func willShowAlert(alert: UIViewController) {
        self.present(alert, animated: true){
        }
    }
}


