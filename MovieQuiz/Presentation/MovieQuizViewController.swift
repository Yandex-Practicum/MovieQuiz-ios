import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    private var currentIndex = 0
    private var correctCount = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? // связываем контроллер и класс QuestionFactory через "композицию", создавая экземпляр внутри контроллера. // также прописываем это свойство не напрямую через класс, а через протокол в котором описана функция// после добавления делегата в фабрику - необходимо его указывать, но через self этого сделать нельзя, тк свойство еще не инициализировано
    private var currentQuestion: QuizQuestion? // аналогично, делаем через композицию
    
    private var alert: AlertPresenterProtocol?
    
    private var statisticService: StatisticService?
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader() ) //здесь инициализируем фабрику

        questionFactory?.loadData() // начинаем загрузку - внутри loadData() в зависимости от состояния вызываются функции didLoadDataFromServer() и didFailToLoadData()
        showLoadingIndicator() // показываем индикатор
        
        //questionFactory?.requestNextQuestion()
        
        alert = AlertPresenter(controller: self)
        
        statisticService = StatisticServiceImplementation()
        
    }
    
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    

    //функция для отображения индикатора
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    
    //функция отображения ошибки
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        // создайте и покажите алерт
        let viewModel = AlertModel(title: "Ошибка",
                                   text: message,
                                   buttonText: "Попробовать еще раз") {[weak self] in
            guard let self = self else {return}
            self.presenter.restartGame() //  откуда рестартГейм и что за объект презентер?
        }
        alert?.showAlert(result: viewModel)
    }
    
    
     func didLoadDataFromServer() {//скрываем индикатор и показываем новый экран
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

     func didFailToLoadData(with error: Error) { // функция для отображения ошибки
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // работа с 2мя кнопками
    @IBAction private func noButtonClicked(_ sender: Any) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: false)
        } else {
            showAnswerResult(isCorrect: true)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    
    //  - QuestionFactoryDelegate -  реализация метода из протокола
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
    
    
    // функция отображения информации о правильности/ неправильности ответа на текущий вопрос
    // в ней же делается переход на след вопрос
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect {
            correctCount += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }

    
    // функция перевода данных из исходного вида QuizQuestion в QuizStepViewModel для последующего отображения на экране
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: String(currentIndex + 1) + "/" + String(questionsAmount))
      }
    
    
    // основная функция, которая отвечает за логику того, что будет показано на экране в зависимости от номера текущего вопроса
    private func showNextQuestionOrResults() {
        if currentIndex == questionsAmount - 1 {
            
            statisticService?.store(correct: correctCount, total: questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
          
            let viewModel = AlertModel(title: "Этот раунд закончен",
                                       text: "Ваш результат: \(correctCount)/\(questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%",
                                       buttonText: "Сыграть еще раз") {
                self.currentIndex = 0
                self.correctCount = 0
                self.questionFactory?.requestNextQuestion()
            }
            
            self.imageView.layer.borderColor = nil
            alert?.showAlert(result: viewModel)

            
        } else {
            currentIndex += 1
            questionFactory?.requestNextQuestion()
            
            self.imageView.layer.borderColor = nil

            }
        }
    
    
    //показываем новую картинку
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image =  step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }

    
}

