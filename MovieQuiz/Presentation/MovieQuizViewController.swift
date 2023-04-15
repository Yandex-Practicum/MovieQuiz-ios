import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService = StatisticServiceImplementation()
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: 1 - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: 2 - QuestionFactoryDelegate
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
    
    // MARK: 3 - func show quiz results
    private func show (quiz result: QuizResultsViewModel) {
        let alertViewModel = AlertModel(title: result.title,
                                        message: result.text,
                                        buttontext: result.buttonText,
                                        completion: { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        
        let alert = AlertPresenter()
        AlertPresenter.present(view: self, alert: alertViewModel)
    }
    
    // MARK: 4 - yes n no buttons
    @IBAction private func noButtonClick(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        freezeButton()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        freezeButton()
    }
    
    // MARK: 5 - func freezeButton // функция заморозки кнопок
    private func freezeButton(){
        if yesButton.isEnabled == true && noButton.isEnabled == true {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else
        if yesButton.isEnabled == false && noButton.isEnabled == false {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    // MARK: 6 - convert // функция конвертации параметра image из String в UIImage
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) /\(questionsAmount)")
    }
    
    // MARK: 7 - funcs showAnswerResult & DispatchQueue
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}

            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            self.imageView.layer.borderWidth = 0
            self.freezeButton()
        }
    }
    
    // MARK: 8 - func show quiz step
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // MARK: 9 - func showNexQuestionOrResults
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, count: currentQuestionIndex, total: questionsAmount)
            statisticService.gamesCount+=1
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на все вопросы!" :
            """
            Ваш результат: \(correctAnswers)/10
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)
            (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: 10 - loading Indicator
    private func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // MARK: 11 - show network error
    private func showNetworkError(message: String){
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttontext: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        AlertPresenter.present(view: self, alert: model)
    }
    
    // MARK: 12 - load/fail load data from server
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    /*
     Mock-данные
     
     Картинка: The Godfather
     Настоящий рейтинг: 9,2
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: The Dark Knight
     Настоящий рейтинг: 9
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: Kill Bill
     Настоящий рейтинг: 8,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: The Avengers
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: Deadpool
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: The Green Knight
     Настоящий рейтинг: 6,6
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: Old
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     Картинка: The Ice Age Adventures of Buck Wild
     Настоящий рейтинг: 4,3
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     Картинка: Tesla
     Настоящий рейтинг: 5,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     Картинка: Vivarium
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     */
}

