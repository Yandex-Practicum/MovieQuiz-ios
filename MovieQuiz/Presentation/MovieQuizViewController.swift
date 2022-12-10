import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    private var statisticService: StatisticService?
    private var correctanswerQuestion = 0
    @IBOutlet private var nobutton: UIButton!
    @IBOutlet private var yesbutton: UIButton!
    // Картинка
    @IBOutlet private var imageView: UIImageView!
    // Текст вопроса
    @IBOutlet private var textLabel: UILabel!
    // Счетчик текущего вопроса
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        showLoadingIndicator()
            }
        @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in guard let self = self else {return}
            self.questionFactory?.loadData()
            self.showLoadingIndicator()
        }
            alertPresenter?.show(results: model)
            }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctanswerQuestion+=1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        imageView.layer.cornerRadius = 20
        self.yesbutton.isEnabled = false
        self.nobutton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else{return}
            self.yesbutton.isEnabled = true
            self.nobutton.isEnabled = true
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    
    private func showNextQuestionOrResults(){
        
        if currentQuestionIndex == questionsAmount - 1{
            self.statisticService?.store(correct: correctanswerQuestion, total: questionsAmount)
            
            
            let text = "Ваш результат: \(correctanswerQuestion)/\(questionsAmount) \n Количество сыграных квизов: \(statisticService?.gamesCount ?? 0) \n      Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString )) \n Средняя точность: \(String(format: "%.2f", 100*(statisticService?.totalAccuracy ?? 0)/Double(statisticService?.gamesCount ?? 0)))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            self.correctanswerQuestion = 0
            show(quiz: viewModel)
        }
                    else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    private func show(quiz result: QuizResultsViewModel) {
        
        
        let alertModel = AlertModel(title: result.title, message: result.text , buttonText: result.buttonText) {[weak self] _ in guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctanswerQuestion = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(results: alertModel)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}


