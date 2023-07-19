import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    
    //Типы на экране
    struct ViewModel {
        let image: UIImage
        let questions: String
        let questionNumber: String
    }
    
    //номер текущего вопроса
    private var currentQuestionIndex = 0
    
    //счетчик правильных ответов
    private var correctAnswers = 0
    
    private let questionAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var statisticService: StatisticService?
    
    private var currentQuestion: QuizQuestion?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory()) 
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        
        screenSettings()
        
        questionFactory?.requestNextQuestion()
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        setUnavailableButtons()
        showAnswerResults(isCorrect: self.currentQuestion?.correctAnswer == false)
    }
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        setUnavailableButtons()
        showAnswerResults(isCorrect: self.currentQuestion?.correctAnswer == true)
        
    }
    
    @IBOutlet private weak var imageViev: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    func didReceiveNextQuestion(question: QuizQuestion?) {  //MARK:
        guard let question = question else {
            return
        }
        
        currentQuestion = question;
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        show(quiz: viewModel)
    }
    
    func showResult() {
        statisticService?.updateGameStatisticService(correct: correctAnswers, amount: questionAmount)
        let gameRecord = GameRecord(correct: correctAnswers, total: questionAmount, date: Date())
        
        if let bestGame = statisticService?.bestGame,
            gameRecord > bestGame {
            statisticService?.store(correct: correctAnswers, total: questionAmount)
        }
        
        let alertModel = AlertModel(
            text: "Этот раунд окончен",
            message: makeMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func makeMessage() -> String { //MARK:
        guard let gamesCount = statisticService?.gamesCount,
              let recordCount = statisticService?.bestGame.correct,
              let recordTotal = statisticService?.bestGame.total,
              let recordTime = statisticService?.bestGame.date.dateTimeString,
              let average = statisticService?.totalAccuracy else {
            return "Ошибка при формировании сообщения"
        }
        
        let message = "Ваш результат: \(correctAnswers)/\(questionAmount)\n"
            .appending("Количество сыгранных квизов: \(gamesCount)\n")
            .appending("Рекорд: \(recordCount)/\(recordTotal) (\(recordTime))\n")
            .appending("Средняя точность \(String(format: "%.2f", average))%")
        return message
    }
    
    // логика перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount - 1 {
            showResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func buttonsIsDisabled(){
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func buttonsIsEnabled(){
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
        
//        //Приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса
//    func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
//        let action = UIAlertAction(title: result.buttonText, style: .default){_ in
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true)
//    }
//
    func show(quiz step: QuizStepViewModel) {
        imageViev.image = step.image
        textLabel.text = step.question
        indexLabel.text = step.questionNumber
        screenSettings()
    }
    
//Конвертация из QuizQuestions -> QuizStepViewModel
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }

    //Меняет цвет рамки
    private func showAnswerResults(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageViev.layer.masksToBounds = true
        imageViev.layer.borderWidth = 8
        imageViev.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.setAvailableButtons()
        }
    }
    // Доступность кнопок
    private func setUnavailableButtons() {
        noButton.isUserInteractionEnabled = false
        yesButton.isUserInteractionEnabled = false
    }
    
    private func setAvailableButtons() {
        noButton.isUserInteractionEnabled = true
        yesButton.isUserInteractionEnabled = true
    }
    
    private func screenSettings() {
        questionTitleLabelStyle()
        counterLabelStyle()
        imageViewStyle()
        imageViewBorderStyle()
        textLabelStyle()
        yesButtonStyle()
        noButtonStyle()
    }
    
    private func questionTitleLabelStyle() {
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.textColor = .ypWhite
    }
    
    private func counterLabelStyle() {
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.textColor = .ypWhite
    }
    
    private func imageViewStyle() {
        imageViev.layer.cornerRadius = 20
        imageViev.contentMode = .scaleAspectFill
        imageViev.backgroundColor = .ypWhite
    }
    
    private func textLabelStyle() {
        textLabel.textColor = .ypWhite
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
    }
    
    private func yesButtonStyle() {
        yesButton.setTitle("Да", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.setTitleColor(.ypBlack, for: .normal)
        yesButton.layer.cornerRadius = 15
        yesButton.backgroundColor = .ypWhite
    }
    
    private func noButtonStyle() {
        noButton.setTitle("Нет", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.setTitleColor(.ypBlack, for: .normal)
        noButton.layer.cornerRadius = 15
        noButton.backgroundColor = .ypWhite
    }
    
    private func imageViewBorderStyle() {
        imageViev.layer.masksToBounds = true
        imageViev.layer.borderWidth = 8
        imageViev.layer.borderColor = UIColor.clear.cgColor
        imageViev.layer.cornerRadius = 20
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
