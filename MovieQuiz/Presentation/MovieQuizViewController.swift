import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
                
     
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    private var statisticService: StatisticService?
    private var correctanswerQuestion = 0
    
       
    @IBOutlet var nobutton: UIButton!
       
    @IBOutlet var yesbutton: UIButton!
           
       // Картинка
    
    @IBOutlet private var imageView: UIImageView!
    
    // Текст вопрса
    
    @IBOutlet private var textLabel: UILabel!
    
    // Счетчик текущего вопроса
    
    @IBOutlet private var counterLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = SatisicServiceImplementation()
               
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {return}
        let givenanswer = false
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {return}
        let givenanswer = true
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
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
            
//
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
    
    
