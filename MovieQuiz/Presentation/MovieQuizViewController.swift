import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    
    // MARK: - Lifecycle
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswear: Int = 0
    private var currentQuestionIndex: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresent: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(),delegate: self)
        alertPresent = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        //userDefaults: UserDefaults(),
        //decoder: JSONDecoder(),
        //encoder: JSONEncoder())
        
        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        //       hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else {return}
                self.currentQuestionIndex = 0
                self.correctAnswear = 0
                
                self.questionFactory?.requestNextQuestion()
            }
          alertPresent?.show(alertModel: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) //  качестве сообщения описание ошибки

    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question ?? question!)
           self.show(quize: viewModel)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
 
    private func show(quize step: QuizStepViewModel){
        imageView.layer.borderColor=UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }

private func show(quiz result: QuizResultsViewModel) {
        statisticService?.store(correct: 1, total: 1)
        
        let alertModel = AlertModel(
            title: "",
            message: "",
            buttonText: "",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswear = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
    
    alertPresent?.show(alertModel: alertModel)
        
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            text: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        if isCorrect {
            correctAnswear += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResult()
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showFinalResult() {
        statisticService?.store(correct: correctAnswear, total: questionsAmount)
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswear = 0
                self?.questionFactory?.requestNextQuestion()
                
            }
        )
        alertPresent?.show(alertModel: alertModel)
    }

    private func makeResultMessage() -> String {
        
        guard let statisticService = statisticService else {
            return "Пока рекордов нет"
        }
        
        let accuracy = String(format: "%.2f" , statisticService.totalAccuracy)
        let totalPlaysCountLine = """
        Количество сыгранных квизов: \(statisticService.gamesCount)
        """
        let currentGameResult = """
        Ваш результат: \(correctAnswear)\\\(questionsAmount)
        """
        var bestGameInfoLine = ""
        if let gameRecord = statisticService.gameRecord {
            bestGameInfoLine = "Рекорд: \(gameRecord.correct)\\\(gameRecord.total)"
            + "(\(gameRecord.date.dateTimeString))"
        }
        let averageAccuaryLine = "Cредняя точность: \(accuracy)%"
        
        let resultMessage = [
            currentGameResult, totalPlaysCountLine, bestGameInfoLine, averageAccuaryLine].joined(separator: "\n")
        
       return resultMessage
    }
        
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
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

