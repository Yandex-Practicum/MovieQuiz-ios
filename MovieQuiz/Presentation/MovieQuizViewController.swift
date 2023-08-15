import UIKit


final class MovieQuizViewController: UIViewController {
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var playedQuizCauntity = 0
    private var currentQuestion: QuizQuestion?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentQuestion = questions[self.currentQuestionIndex]
        if let currentQuestion{
            let convertedModel = convert(model: currentQuestion)
            show(quiz: convertedModel)
        }
    }
    
    
    @IBAction private func noButtonClick(_ sender: Any) {
        let answer = false
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    @IBAction private func yesButtonClick(_ sender: Any) {
        let answer = true
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text + "\n" + result.description,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return quizStepViewModel
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if(isCorrect){
            imageBorder(
                borderColor: YPColors.green
            )
        }else{
            imageBorder(
                borderColor: YPColors.red
            )
        }
        if isCorrect {
            correctAnswers += 1
        }
        if currentQuestionIndex == questions.count{
            playedQuizCauntity += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageBorder(
                borderColor: YPColors.black
            )
        }
    }
    
    func imageBorder(borderColor: CGColor){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor
        imageView.layer.cornerRadius = 15
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let playedQuizCauntity = "Количество сыгранных квизов: \(playedQuizCauntity)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                description: playedQuizCauntity,
                buttonText: "Сыграть ещё раз")
            showAlert(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
}

