import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegatePrototocol {

    // MARK: - Lifecycle
    
    //Привязываем этикетку со значение счетчика вопросов
    @IBOutlet private weak var counterLabel: UILabel!
    
    //Привязываем изображение постера вопроса
    @IBOutlet private weak var imageView: UIImageView!
    
    //Привязываем этикетку текста вопроса
    @IBOutlet private weak var textLabel: UILabel!
    
    //Привязываем кнопку "Да" к коду
    @IBOutlet private weak var yesButton: UIButton!
    
    //Привязываем кнопку "Нет" к коду
    @IBOutlet private weak var noButton: UIButton!
    
    //Создаем прееменную текущего индекса вопроса
    private var currentQuestionIndex = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Создаем переменную отслеживающую текущее количество правильных ответов
    var correctAnswers = 0
    
    //Определяем переменны необходимые для связи MobieQuizViewController c "Фабрикой вопросов"
    //Определяем максимальное количество вопросов
    private var questionAmount: Int = 10
    
    //Определяем "Фабрику впоросов"
    private lazy var questionFactory = QuestionFactory(movieLoader: MovieLoader())
    
    //Вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    //Определяем клас работы с Алертом
    private var alertPresenter = AlertPresenter()
    
    //Определяем класс обработки общей статистики квиза
    private var statisticImplementation: StatisticServiceProtocol = StatisticServiceImplementation()
    
    //Определяем внешний вид статус бара в приложении
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //инъекция зависимости для определения делегата
        questionFactory.delegate = self
        
        //Загружаем внешинй вид изображения ImageView в соответствии с моделью в Figma
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        showLoadingIndictor()
        questionFactory.loadData()
        
        //Загружаем необходимый вид статус бара
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: Начало описания методов
    
    private func showLoadingIndictor(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message: String){
        hideLoadingIndicator()
        
        let networkConnectionAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз"){ [weak self] in
            guard let selfAction = self else {return}
            
            selfAction.correctAnswers = 0
            selfAction.currentQuestionIndex = 0
            selfAction.questionFactory.requestNextQuestion()
            
        }
        alertPresenter.showAlert(quiz: networkConnectionAlert, controller: self)
    }
    
    //MARK: Описание метдов Делегата
    
    func didFinishReceiveQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    ///Метод осуществляющий преобразования структуры модели вопроса QuizQuestiion в структур модели отображения на экране QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(data: model.image) ?? UIImage()
        let questionText: String = model.text
        let questionNumber: String = "\(currentQuestionIndex + 1)/\(questionAmount)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: questionNumber)
    }
    
    //Метод блокировки кнопок экрана
    private func isButtonsBlocked(state: Bool) {
        if state {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    //Метод загружающий внешний вид модели QuizStepViewModel на экран
    private func show(quiz step: QuizStepViewModel) {
        
        UIView.transition(with: imageView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = step.image
            self.imageView.layer.borderWidth = 0 //Скраваем рамку
        },
                          completion: { _ in
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.isButtonsBlocked(state: false) // Разрешаем действе действие кнопок
        })
    }
    
    //Метод который меняе цвет рамки и вызывает метод перехода
    //метод принимает на въод булево значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        
        isButtonsBlocked(state: true) // Запрещаем действие кнопок
        imageView.layer.borderWidth = 8 // Показываем рамку
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypgreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypred.cgColor
        }
        
        //Делаем задержку перед отобрадение следующего вопрос
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            guard let dispatch = self else { return }
            dispatch.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionAmount - 1 {
            //Анализируем лучшую сыгранную партию
            statisticImplementation.store(correct: correctAnswers, total: questionAmount)
            
            //Определяем формат даты в виде 03.06.22 03:22
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY HH:mm"
            let formattedDate = dateFormatter.string(from: statisticImplementation.bestGame.date)
            
            //Данные для модели Алерта
            let alerTitle = "Этот раунд окончен!"
            let alertMessage = """
            Ваш результат: \(correctAnswers)/\(questionAmount)
            Количество сыгранных квизов: \(statisticImplementation.gamesCount)
            Рекорд: \(statisticImplementation.bestGame.correct)/\(statisticImplementation.bestGame.total) (\(formattedDate))
            Средняя точность: \(String(format: "%.2f", statisticImplementation.totalAccurancy * 100))%
            """
            let alertButtonText = "Сыграть ещё раз"
            
            //Подготавливаем модель Алерта
            let alertModel = AlertModel(title: alerTitle, message: alertMessage, buttonText: alertButtonText) { [ weak self ] in
                
                //В замыкании определяем начальное состояние игры после завершения партии
                if let selfAction = self {
                    // обнуляем счетчик вопросов
                    selfAction.correctAnswers = 0
                    
                    // обнуляем счетчик правильных вопросов
                    selfAction.currentQuestionIndex = 0
                    
                    //Загружаем на экран первый вопрос
                    selfAction.questionFactory.requestNextQuestion()
                }
            }
            
            alertPresenter.showAlert(quiz: alertModel, controller: self)
            
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    // MARK: - ActionButtons
    
    //Определяем действие кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    //Определяем действие кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
}
