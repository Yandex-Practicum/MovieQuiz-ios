import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if !currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }

    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizeQuestion?
    

    

    

    
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel: QuizeStepViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: "")
    private var resultsViewModel: QuizeResultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy: Double = 0.0
    private var buttonsBlocked: Bool = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(image: model.image, question: model.text, questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)")
    }

    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        guard let tmpQuestion = currentQuestion else {
            return
        }
        currentViewModel = convert(model: tmpQuestion)
        moviePoster.image = UIImage(named: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        //buttonsBlocked = false
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func show(quize result: QuizeResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз!", style: .default, handler: { _ in
            guard let tmpQuestion = self.currentQuestion else {
                return
            }
            self.show(quize: self.convert(model: tmpQuestion))
        })

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moviePoster.layer.borderWidth = 8
        if isCorrect {
            moviePoster.layer.borderColor = greenColor
            corrects += 1
        }
        else {
            moviePoster.layer.borderColor = redColor
            wrongs += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        questionNumberGlobal += 1
        guard questionNumberGlobal < questionsAmount else {
            rounds += 1
            if corrects > records {
                records = corrects
                let temporaryDateVar = Date()
                recordDate = temporaryDateVar.dateTimeString
            }
            if corrects > 0 {
                accuracy.append((Double(corrects) / Double(questionsAmount)) * 100.0)
            }
            else {
                accuracy.append(0.0)
            }
            if !accuracy.isEmpty {
                sumAccuracy = 0.0
                for element in accuracy {
                    sumAccuracy += element
                }
                print(sumAccuracy)
                avgAccuracy = sumAccuracy / Double(accuracy.count)
            }
            if corrects != questionsAmount {
                resultsViewModel.title = "Этот раунд окончен!"
            }
            else {
                resultsViewModel.title = "Потрясающе!"
            }
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\nКоличество сыграных квизов:\(rounds)\nРекорд: \(records)/\(questionsAmount) (\(recordDate))"
            resultsViewModel.text += "\nСредняя точность: \(avgAccuracy)%"
            corrects = 0
            wrongs = 0
            questionNumberGlobal = 0
            show(quize: resultsViewModel)
            return
        }
        questionFactory.requestNextQuestion(completion: { [weak self] question in
            guard
                let self = self,
                let question = question
            else {
                return
            }
            let currentQuestion = question
            print(currentQuestion.image)
            show(quize: self.convert(model: currentQuestion))
        })
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        questionFactory.requestNextQuestion(completion: { [weak self] question in
            guard
                let self = self,
                let question = question
            else {
                return
            }
            self.currentQuestion = question
            let viewModel = self.convert(model: question)
            DispatchQueue.main.async {
                self.show(quize: viewModel)
            }
        })
    }
}
