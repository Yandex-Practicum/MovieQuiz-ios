import UIKit

class MovieQuizViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private let questionsCount = 10
    
    private func show(quiz step: QuizStepViewModel) {
      imageView.layer.borderColor = UIColor.clear.cgColor
      imageView.image = step.image
      textLabel.text = step.question
      counterLabel.text = step.questionNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactoryImpl(delegate: self)
        
        questionFactory?.requestNextQuestion()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer) // 3
    }
  
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true // 2
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer) // 3
    }
    
   
    
  
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel( // 1
            image: UIImage(named: model.image) ?? UIImage(), // 2
            question: model.text, // 3
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)") // 4
        return questionStep
    }

    // приватный метод, который и меняет цвет рамки, и вызывает метод перехода
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsCount - 1 {
        
            let text = correctAnswers == questionsCount ?
            
            "Поздравляем Вы ответилт на 10 из 10!" :
            "Вы ответилт на \(correctAnswers) из 10, попробуйте ещё раз"
            
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        // константа с кнопкой для системного алерта
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0 // 1
            
            self.correctAnswers = 0
           
              self.questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
        
    }
}

