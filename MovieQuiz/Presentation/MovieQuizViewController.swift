import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    // MARK: - Properties

    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var currentQuestionIndex = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textOfQuestion: UILabel!
    @IBOutlet private weak var questionLabelText: UILabel!
    @IBOutlet private weak var indexQuestionText: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        }
        
       // let currentQuestion = firstQuestion
      
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        blockedButton()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        blockedButton()
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        //quizQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
                    
                }
                
            }

    // MARK: - Private Functions
    
    private func unlockedButton() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func blockedButton() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.cornerRadius = 20
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return } // optional weak link is commonly deployed
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.unlockedButton()
        }
    }


    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
  // MARK: showNextQuestionOrResults
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            let finalScreen = AlertModel (// QuizResultViewModel(
                title: "Этот раунд окончен!",
                message:"test message",
                //text: "Ваш результат: \(correctAnswers) из 10",
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else {return}
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                })
            alertPresenter?.showQuizResult(model: finalScreen)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            }
           
        }
        
    }
    
    

        
    

   
