import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter : AlertPresenterProtocol?
    private var statisticService : StatisticService?
    
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var userAnswer = false
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var noAnswerButton: UIButton!
    @IBOutlet weak var yesAnswerButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        
        presentNextQuizStepQuestion()
        
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noAnswerButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
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
            self?.currentQuestionIndex += 1
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
        if currentQuestionIndex == questionsAmount {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            showQuizResults()
        } else {
            presentNextQuizStepQuestion()
        }
    }
    
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


extension MovieQuizViewController : QuestionFactoryDelegate {
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let quizStepViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStepViewModel: quizStepViewModel)
        }
        
        
    }
}

extension MovieQuizViewController : AlertPresenterDelegate {
    // MARK: - AlertPresenterDelegate
    func willShowAlert(alert: UIViewController) {
        self.present(alert, animated: true){
        }
    }
    
    
    
}


