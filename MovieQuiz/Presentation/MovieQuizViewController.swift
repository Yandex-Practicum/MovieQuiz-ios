
//import UIKit
//
//final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
//
//
//
//    //Do statusBar white
//       override var preferredStatusBarStyle: UIStatusBarStyle {
//           return .lightContent
//       }
//
//
//    private var questionFactory: QuestionFactory?
//    private var currentQuestion: QuizQuestion?
//    private var alertPresenter: AlertPresenterProtocol?
//    private var statisticService: StatisticService?
//    private var currentQuestionIndex = 0
//    private var correctAnswers: Int = 0
//    private let questionsAmount: Int = 10
//
//
//    @IBOutlet private weak var imageView: UIImageView!
//    @IBOutlet private weak var textLabel: UILabel!
//    @IBOutlet private weak var counterLabel: UILabel!
//    @IBOutlet private weak var textOfQuestion: UILabel!
//    @IBOutlet private weak var questionLabelText: UILabel!
//    @IBOutlet private weak var indexQuestionText: UILabel!
//    @IBOutlet private weak var noButton: UIButton!
//    @IBOutlet private weak var yesButton: UIButton!
//
//
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    private func hideLoadingIndicator(){
//        activityIndicator.isHidden = true
//        activityIndicator.stopAnimating()
//    }
//
//    private func showLoadingIndicator(){
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
//    }
//
//    private func showNetworkError(message: String){
//        hideLoadingIndicator()
//
//        let model = AlertModel(title: "Ошибка",
//                               message: message,
//                               buttonText: "Попробовать еще раз") { [weak self] in
//            guard let self = self else { return }
//
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//
//            self.questionFactory?.requestNextQuestion()
//        }
//
//        alertPresenter?.showQuizResult( model: model )
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        alertPresenter = AlertPresenter(delegate: self)
//        questionFactory = QuestionFactory(delegate: self)
//        questionFactory?.requestNextQuestion()
//        statisticService = StatisticServiceImplementation()
//    }
//
//
//    // Buttons actions
//
//    @IBAction private func yesButtonClicked(_ sender: UIButton) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = true
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//    }
//    @IBAction private func noButtonClicked(_ sender: UIButton) {
//        guard let currentQuestion = currentQuestion else {
//            return
//        }
//        let givenAnswer = false
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//        blockButton()
//    }
//
//
//    private func unlockButton() {
//        noButton.isEnabled = true
//        yesButton.isEnabled = true
//    }
//
//    private func blockButton() {
//        noButton.isEnabled = false
//        yesButton.isEnabled = false
//    }
//
//    private func show(quiz step: QuizStepViewModel) {
//        imageView.image = step.image
//        imageView.layer.cornerRadius = 20
//        textLabel.text = step.question
//        counterLabel.text = step.questionNumber
//    }
//
//    func didRecieveNextQuestion(question: QuizQuestion?) {
//        guard let question = question else { return }
//        currentQuestion = question
//        let viewModel = convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//
//    }
//
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
//    }
//
//    private func showAnswerResult(isCorrect: Bool) {
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.cornerRadius = 20
//        if isCorrect {
//            imageView.layer.borderColor = UIColor.ypGreen.cgColor
//            correctAnswers += 1
//        } else {
//            imageView.layer.borderColor = UIColor.ypRed.cgColor
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
//            guard let self = self else { return } // optional weak link is commonly deployed
//            self.showNextQuestionOrResults()
//            self.imageView.layer.borderWidth = 0
//            self.unlockButton()
//        }
//    }
//
//
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
//                                 question: model.text,
//                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
//
//    private func showNextQuestionOrResults() {
//        imageView.layer.borderWidth = 0
//        if currentQuestionIndex == questionsAmount - 1 {
//            imageView.layer.borderWidth = 8
//            statisticService?.store(correct: correctAnswers, total: questionsAmount)
//            guard let gamesCount = statisticService?.gamesCount else { return }
//            guard let bestGame = statisticService?.bestGame else { return }
//            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
//            // QuizResultViewModel
//
//            let alert = AlertModel (title: "Этот раунд окончен!",
//                                          message: """
//                                                    Ваш результат: \(correctAnswers)/\(questionsAmount)
//                                                    Количество сыгранных квизов: \(gamesCount)
//                                                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
//                                                    Средняя точность: \(String(format: "%.2f", totalAccuracy))%
//                                                    """ ,
//                                          buttonText: "Сыграть еще раз",
//                                          completion: { [weak self] in
//                guard let self = self else { return }
//                self.imageView.layer.borderWidth = 0
//                self.currentQuestionIndex = 0
//                self.correctAnswers = 0
//                self.questionFactory?.requestNextQuestion()
//            })
//            alertPresenter?.showQuizResult(model: alert)
//        } else {
//            currentQuestionIndex += 1
//            questionFactory?.requestNextQuestion()
//        }
//
//    }
//
//}

import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0     //счетчик правильных ответов
    private var currentQuestionIndex = 0    //индекс текущего вопроса
    private let questionsAmount: Int = 10
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?


//    MARK - Button
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion(button: sender)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion(button: sender)
    }

    
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        showLoadingIndicator()
        questionFactory?.loadData()
    }
       
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // выключаем анимацию
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(result: model)
    }
    
    // MARK: - QuestionFactoryDelegate

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
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
//    MARK - Private functions
      
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    //Заполняем счетчик, картинку, текст вопроса данными. Рамку убираем
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
        
    //функция показывающая правильный/неправильный результат
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.cornerRadius = 20
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
    }
    
    private func waitShowNextQuestion(button: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            button.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == self.questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
            let localizedTime = statisticService.bestGame.date.dateTimeString
            let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"

            let text =
            """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGameStats) (\(localizedTime))
            Средняя точность: \(totalAccuracyPercentage)
            """

            let alert = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }

                self.currentQuestionIndex = 0 // сброс счета
                self.correctAnswers = 0

                self.questionFactory?.requestNextQuestion()  // заново показываем первый вопрос
            }


            alertPresenter?.show(result: alert)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1
            questionFactory?.requestNextQuestion()
        }
    }
}








