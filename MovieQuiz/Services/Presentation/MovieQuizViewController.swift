import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var questionLabel: UILabel!
    
    @IBOutlet private var indexLabel: UILabel!
    
    private var currentQuestionIndex = 0 //текущий индекс
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? 
    private var currentQuestion: QuizQuestion? //текущий вопрос который будет видеть пользователь
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceImplementation?
    

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return questionStep
    }
    
    private func show (quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        //метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        //код который должен быть вызван через одну секунду:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in //dispatch - отправка, queue - очередь
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else { // показываем следующий вопрос
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
        private func showFinalResults() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
          
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: makeMessage(),
                buttonText: "Сыграть еще раз" ,
                completion: { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    self?.questionFactory?.requestNextQuestion()
                } )
                alertPresenter?.show(alertModel: alertModel)
                }
                
                func makeMessage () -> String {
                    guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
                        assertionFailure("error")
                        return ""}
                    
                    let string1 = "Ваш результат: \(correctAnswers) / \(questionsAmount)"
                    let string2 = "Количество сыграных квизов: \(statisticService.gamesCount)"
                    let string3 = "Рекорд: \(bestGame.correct) / \(bestGame.total) \n \(bestGame.date.dateTimeString)"
                    let string4 = "Средняя точность: \(String(format:"%.2f", statisticService.totalAccuracy)) %"
                        let message = [
                            string1, string2, string3, string4
                        ].joined(separator: "\n")
                  
                    return message
                    
                    }
                

    //метод который вызывается когда пользователь жмет на кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
            
        }
        let givenResult = false
        showAnswerResult(isCorrect: givenResult == currentQuestion.correctAnswer)
    }
    //метод когда пользователь жмет на кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
            
        }
        let givenResult = true
        showAnswerResult(isCorrect: givenResult == currentQuestion.correctAnswer)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(alertDelegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation().self
        print(NSHomeDirectory())
        print(Bundle.main.bundlePath)

    }
        
        // MARK: - QuestionFactoryDelegate
        
        func didReceiveNextQuestion(question: QuizQuestion?) { //реализуем протокол делегата
            guard let question = question else {
                return
            }
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
    }


        
//        yesButton.titleLabel!.font = UIFont(name: "YSDisplay-Medium", size: 20)
//        noButton.titleLabel!.font = UIFont(name: "YSDisplay-Medium", size: 20)
//        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
//        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
//    }

/*
 Mock-данные (от англ. имитация)
 
 
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
