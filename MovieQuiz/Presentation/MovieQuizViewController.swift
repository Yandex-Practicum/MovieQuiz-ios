import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {return}
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }}

    override func viewDidLoad() {
        super.viewDidLoad()
   
        alertPresenter = AlertPresenter(alertController: self)
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
    }
    // MARK: - QuestionFactoryDelegate
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var alertPresenter : AlertPresenter?
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol? = nil
    private var statisticService: StatisticService?
    
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
/*
        Рабочий вариант, но без записи результата
        private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {

            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = AlertModel(title: "Этот раунд окончен!",message: text, buttonText: "Сыграть ещё раз")
            
          
            self.alertPresenter?.show(result: viewModel)
            self.currentQuestionIndex = 0
            self.correctAnswers = 0            
        }
        else {currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        
*/
    private func showNextQuestionOrResults() {
          if currentQuestionIndex == questionsAmount - 1 {
              statisticService?.store(correct: self.correctAnswers, total: self.questionsAmount)
              guard  let gameCount = statisticService?.gamesCount,
                    let bestGame = statisticService?.bestGame,
                    let totalAccuracy = statisticService?.totalAccuracy  else { return  }
              
              let messageResult = """
                Вы результат: \(correctAnswers)/\(questionsAmount) \n
                Количество сыгранных квизов: \(gameCount) \n
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))\n
                Средняя точность: \(totalAccuracy)%
                """

              let viewModel = AlertModel(title: "Этот раунд окончен!", message: messageResult,buttonText: "Сыграть ещё раз")
              currentQuestionIndex = 0
              self.currentQuestionIndex = 0
              self.alertPresenter?.show(result: viewModel)
              }
           
              
           else {
              currentQuestionIndex += 1
                  questionFactory?.requestNextQuestion()
          }
      }
        
    private func show(quiz step: QuizStepViewModel) {
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    private func showAnswerResult(isCorrect: Bool) {
    
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
 
        
        
  
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers = correctAnswers + 1
        }
        else{
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
            self.YesButton.isEnabled = false
            self.noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.YesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.imageView.layer.borderWidth = 0 // нужно же убрать рамку!
            self.showNextQuestionOrResults()
        }
    }
/*
      Получается, что нам не требуется отдельый shoe для результатов? Мы ведь показать через AlertPresenter?
      private func show(quiz result: QuizResultsViewModel) {
      //  let alert = UIAlertController(
      //      title: result.title,
      //      message: result.text,
      //      preferredStyle: .alert)
      //  let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
      //      guard let self = self else {return}
           
            
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = AlertModel(title: "Этот раунд окончен!",message: text, buttonText: "Сыграть ещё раз")
            
            
            self.alertPresenter?.show(result: viewModel)
                                        
            //  if let firstQuestion = self.questionFactory.requestNextQuestion() {
           //     self.currentQuestion = firstQuestion
          //      let viewModel = self.convert(model: firstQuestion)
                
          //      self.show(quiz: viewModel)
            self.questionFactory?.requestNextQuestion()
          //  }
        
        //alert.addAction(action)
        //self.present(alert, animated: true, completion: nil)
    
    }
 */
}

