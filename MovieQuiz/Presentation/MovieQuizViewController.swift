import UIKit


final class MovieQuizViewController: UIViewController {
    
//    private let presenter = MovieQuizPresenter()
    private var presenter: MovieQuizPresenter!
//    private var currentQuestionIndex: Int = 0
//    private let questionsAmount: Int = 10
//    var questionFactory: QuestionFactoryProtocol?
//    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
//    var statisticService: StatisticService?
//    private var correctanswerQuestion = 0
    @IBOutlet  var nobutton: UIButton!
    @IBOutlet var yesbutton: UIButton!
    // Картинка
    @IBOutlet var imageView: UIImageView!
    // Текст вопроса
    @IBOutlet private var textLabel: UILabel!
    // Счетчик текущего вопроса
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    let galertt = UIAlertController()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
//        statisticService = StatisticServiceImplementation()
//        questionFactory?.loadData()
//        showLoadingIndicator()
//        presenter = MovieQuizPresenter()
            }
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            
            presenter.noButtonClicked()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        presenter.yesButtonClicked()
    }
    
     func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
     func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in guard let self = self else {return}
//            self.questionFactory?.loadData()
            self.showLoadingIndicator()
            self.presenter.restartGame()
//            self.correctanswerQuestion = 0
        }
            alertPresenter?.show(results: model)
            }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }
//
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    func hightLightImageBorder(isCorrectAnswer: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        imageView.layer.cornerRadius = 20
        
    }
    
    
//    func showAnswerResult(isCorrect: Bool) {
//        
//        presenter.didAnswerQuestion(isCorrect: isCorrect)
//        
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
//        imageView.layer.cornerRadius = 20
//        self.yesbutton.isEnabled = false
//        self.nobutton.isEnabled = false
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            
//            guard let self = self else{return}
//            self.yesbutton.isEnabled = true
//            self.nobutton.isEnabled = true
//            self.imageView.layer.borderColor = UIColor.clear.cgColor
//            
////            self.presenter.questionFactory = self.questionFactory
//            self.presenter.showNextQuestionOrResults()
//        }
//        
//    }
    
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    
//    private func showNextQuestionOrResults(){
        
        
        
//        if presenter.isLastQuestion(){
//            self.statisticService?.store(correct: presenter.correctanswerQuestion, total: presenter.questionsAmount)
//
//
//            let text = "Ваш результат: \(presenter.correctanswerQuestion)/\(presenter.questionsAmount) \n Количество сыграных квизов: \(statisticService?.gamesCount ?? 0) \n      Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(presenter.questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString )) \n Средняя точность: \(String(format: "%.2f", 100*(statisticService?.totalAccuracy ?? 0)/Double(statisticService?.gamesCount ?? 0)))%"
//            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
//                                                 text: text,
//                                                 buttonText: "Сыграть еще раз")
//            self.presenter.restartGame()
//            show(quiz: viewModel)
//        }
//                    else {
//                        presenter.switchToNextQuestion()
//                        self.presenter.restartGame()
//        }
//    }
    
    
    func show(quiz result: QuizResultsViewModel) {
        
        
        let alertModel = AlertModel(title: result.title, message: result.text , buttonText: result.buttonText) {[weak self] _ in guard let self = self else {return}
//            self.presenter.currentQuestionIndex = 0
            self.presenter.restartGame()
            self.presenter.restartGame()
        }
        alertPresenter?.show(results: alertModel)
        
    }
    
    
    
//    func didRecieveNextQuestion(question: QuizQuestion?) {
//
//        presenter.didRecieveNextQuestion(question: question)
//    }
//
    
}


