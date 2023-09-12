import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var isButtonEnabled = true // Создает кнопку которая Выключает кнопку на 1 секунду,для того чтобы небыло залипания
    
    /* - questionsAmount — общее количество вопросов для квиза. У нас оно всегда будет равно десяти. Вы можете поменять значение на любое другое, но мы оставим десять, потому что это число оптимально для комфортной игры.
     - questionFactory — та самая фабрика вопросов, которую мы создали. Наш контроллер будет обращаться за вопросами именно к ней.
     - currentQuestion — текущий вопрос, который видит пользователь.
     Чтобы использовать фабрику в MovieQuizViewController, мы применяем композицию. То есть контроллер сам создал экземпляр фабрики, которую теперь будет использовать. У нас простое однооконное приложение, и такое решение является достаточным. Давайте же приступим к исправлению ошибок! */
    private let questionsAmount: Int = 10
    
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenterImpl(viewController: self)
        statisticService = StatisticServiceImplentation(userDefaults: UserDefaults(), decoder: JSONDecoder(), encoder: JSONEncoder())
        
        questionFactory?.requestNextQuestion()
    }
    
    /*      let alert = UIAlertController(
     title: "Этот раунд закончен!",
     message: "Ваш результат \(correctAnswers)/10",
     preferredStyle: .alert)
     let action = UIAlertAction(title: "OK", style: .default) {  [weak self] _ in
     guard let self = self else { return }
     self.currentQuestionIndex = 0
     self.correctAnswers = 0
     
     questionFactory?.requestNextQuestion()
     
     }
     alert.addAction(action)
     
     self.present(alert, animated: true, completion: nil)
     }*/
    
    
    // MARK:  - QuestionFactoryDelegate
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    
    
    
    /*  let alert = UIAlertController(
     title: result.title,
     message: result.text,
     preferredStyle: .alert)
     
     let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
     guard let self = self else { return }
     self.currentQuestionIndex = 0
     self.correctAnswers = 0
     
     questionFactory?.requestNextQuestion()
     }
     
     alert.addAction(action)
     
     self.present(alert, animated: true, completion: nil)
     } */
    
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            imageView.layer.cornerRadius = 20
            correctAnswers += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderColor = nil
                self.imageView.layer.borderWidth = 0
                self.showNextQuestionOrResults()
            }
            
            
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            imageView.layer.cornerRadius = 20
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderColor = nil
                self.imageView.layer.borderWidth = 0
                self.showNextQuestionOrResults()
            }
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if isButtonEnabled {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = true
            isButtonEnabled = false
            
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.isButtonEnabled = true
            }
        }
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if isButtonEnabled {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let givenAnswer = false
            isButtonEnabled = false
            
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.isButtonEnabled = true
            }
        }
    }
    
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
            // идём в состояние "Результат квиза"
            
        } else {
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            
            
            questionFactory?.requestNextQuestion()
            
        }
    }
    
    
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        guard let bestGame = statisticService?.bestGame else {
            assertionFailure("error message")
            return
        }
        
        let alertModel = AlertModel(
            title: "Игра Окончена",
            message: makeResultMessage(),
            buttonText: "OK",
            completion: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
        
    }
            
            private func makeResultMessage() -> String {
                guard let statisticService = statisticService,
                     let bestGame = statisticService.bestGame else {
                    assertionFailure("errroor")
                    return ""
                }
                
                
                let accuracy = String(format: "%.2f",statisticService.totalAccuracy)
                let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
                let currentGameResultLine = "Ваш результат, \(correctAnswers)\\ \(questionsAmount)"
                let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
                + " (\(bestGame.date.dateTimeString))"
                let averageAccuracyLine = "Средняя точность: \(accuracy)%"
                
                let resultMessage = [
                    currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
                ].joined(separator: "\n")
                return resultMessage
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
