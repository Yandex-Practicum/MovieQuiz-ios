import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - private Outlet Variables
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    
    // MARK: - private Variables
    private let questionsAmount: Int = 10 //кол-во вопросов
    //иньектируем фабрику через свойство
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion? //текущий вопрос
    private var currentQuestionIndex: Int = 0 //индекс текущего вопроса
    private var correctAnswers: Int = 0 // правильные ответы
    private var alertPresent: AlertPresenterProtocol? //Иньектируем алерт через свойство
    private var statisticService: StatisticService? //Иньектируем StaticticService через свойство
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius  = 20
        imageView.layer.masksToBounds = true
        questionFactory = QuestionFactory(delegate: self)
        alertPresent = AlertPresenter(viewController: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonAction(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        yesButtonOutlet.isUserInteractionEnabled = false
        noButtonOutlet.isUserInteractionEnabled = false
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButtonOutlet.isUserInteractionEnabled = true
            self.noButtonOutlet.isUserInteractionEnabled = true
        }
    }
    
    private func show(quiz step: QuizStepViewModel) { //метод показа вопроса
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber// здесь мы заполняем нашу картинку, текст и счётчик данными
    }


    
    private func showNextQuestionOrResults() { //метод показа следующего вопроса или алерта с результатами
        if currentQuestionIndex == questionsAmount - 1 {
            // сохраняем значения правильных ответов за этот раунд и количества вопросов за этот раунд
                         statisticService?.store(correct: correctAnswers, total: questionsAmount)

                        guard let bestGame = statisticService?.bestGame else {
                            print("a")
                            return
                        }
                        guard let gamesCount = statisticService?.gamesCount else {
                            print("b")
                            return
                        }
                        guard let totalAccuracy = statisticService?.totalAccuracy else {
                            print("c")
                            return
                        }
                         let title = "Этот раунд окончен!"
                         let buttonText = "Сыграть еще раз"
                         let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыграных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString)) \n Средняя точность: \(String(format:"%.2f", totalAccuracy))%"
            
            let alertModel = AlertModel(
                title: title,
                message: text,
                buttonText: buttonText,
                completion: { [weak self] in
                                guard let self = self else { return }
                                self.correctAnswers = 0
                                 self.currentQuestionIndex = 0
                                 self.questionFactory?.requestNextQuestion()
                             })
            alertPresent?.show(results: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
