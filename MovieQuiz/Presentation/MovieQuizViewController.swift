import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate,AlertPresenterDelegate {
   
    
    
 private   func didRecieveAlertModel(alertModel: AlertModel) {
        
        
        alertPresenter?.makeAlertController(alertModel: alertModel)
      

          }
    
    
    
    func present(_ alertController: UIAlertController) {
        present(alertController, animated: true)
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
    
    @IBOutlet weak var noButtonClicked: UIButton!
    
    @IBOutlet weak var yesButtonClicked: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        
    }
    
    
    private var correctAnswers: Int = 0  // счетчик правильных ответов
    private  var currentQuestionIndex : Int = 0 // индекс текущего вопроса
    
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter?
    
    
    private var statisticService: StatisticServiceImplementation
    
    
    
    private func convert(model : QuizQuestion) -> QuizStepViewModel {// конвертация из мок данных в модель которую надо //показать на экране
        
        
        
        return QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(), // Распаковка картинки
            question: model.text, // берем текст вопроса
            questionNumber: "\(currentQuestionIndex + 1) / \(questionsAmount)"  // высчитываем номер вопроса
        )
        
    }
    
    private func show(quiz step: QuizStepViewModel) {  // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        textLabel.text = step.question
        counetLabel.text = "\(step.questionNumber)"
        
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // счетчик правильных ответов
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        yesButtonClicked.isEnabled = false
        noButtonClicked.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in //задержка 1 сек перед показом след вопроса
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButtonClicked.isEnabled = true
            self.noButtonClicked.isEnabled = true
            
        }
        
    }
    
//
//    private func show(quiz result: QuizResultsViewModel ) {
//        let alert = UIAlertController (
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title : result.buttonText, style: .default) { [weak self] _ in
//
//            guard let self = self else { return }
//
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0 //Обнуляем счетчик правильных ответов
//
//            self.questionFactory?.requestNextQuestion()
//        }
//
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
    
    
    
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount-1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            
            "Ваш результат:\(correctAnswers)/10 \n "
            "Количество сыгранных квизов:\(statisticService.gamesCount) \n"
            "Рекорд: \(statisticService.bestGame) \n"
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            

/*
  сравнивать рез-т текущей игры с рекордом из UserDefaults
 обновить рекорд если лучше
 */
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            didRecieveAlertModel(alertModel: AlertModel(title: "Этот раунд окончен!",
                                                        message: text,
                                                        buttonText: "Сыграть еще раз",
                                                        completion: {[weak self] in
                
                guard let self = self else {return}
                self.currentQuestionIndex = 0
                self.correctAnswers = 0 //Обнуляем счетчик правильных ответов
//                self.didReceiveNextQuestion(question: QuizQuestion?)
                self.questionFactory?.requestNextQuestion()
            }))
        } else{
            currentQuestionIndex += 1
//            didReceiveNextQuestion(question:QuizQuestion)
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation(totalAccuracy: <#T##Double#>, gamesCount: <#T##Int#>)
        
    }
    
}

