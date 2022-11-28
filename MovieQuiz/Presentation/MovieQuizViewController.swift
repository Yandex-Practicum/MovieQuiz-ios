import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService!
  
    //MARK: - View Did Loade
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
    }
    
    //MARK: - Did Load Date From Server
    
    internal func didLoadDateFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    //MARK: - Did Fail To Load Data
    
    internal func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // Берем в качестве сообщения описание ошибки
    }
    
    // MARK: - QuestionFactoryDelegate

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private functions
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индекатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
            activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] _ in
            guard let self = self else {return}
            self.restartGame()
        }
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.showAlert(quiz: model)
    }
    
    private func restartGame() {
        self.currentQuestionIndex = 0
        self.questionFactory?.requestNextQuestion()
        self.correctAnswers = 0
    }
    
    private func showAnswerResult(isCorrect: Bool){
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    self.showNextQuestionOrResults()
                    self.imageView.layer.borderWidth = 0
        }
    }
    
    private func show(quiz step: QuizStepViewModel){
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let bestGame = statisticService?.bestGame else {return}
            let text = """
                       Ваш результат: \(correctAnswers) из \(questionsAmount)
                       Количество сыгранных квизов: \(statisticService.gamesCount)
                       Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(bestGame.date.dateTimeString))
                       Средняя точность: \(Int(statisticService.totalAccuracy))%
                       """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            
            self.correctAnswers = 0
            show(quiz: viewModel)
        }else{
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
            let alertModel = AlertModel(
                title: result.title,
                message: result.text,
                buttonText: result.buttonText)
                { [weak self] _ in
                    guard let self = self else { return }
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.showAlert(quiz: alertModel)
        }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    // MARK: - Action button
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        blockButtons()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        blockButtons()
    }
    
    // MARK: - URL
    func sendFirstRequestion() {
        //создаем адрес
        guard let url = URL(string: "https://imdb-api.com/en/API/MostPopularTVs/k_q8w9sd9g") else { return }
        // создаем запрос
        var request = URLRequest(url: url)
        
        /*
           Также запросу можно добавить HTTP метод, хедеры и тело запроса.
           
           request.httpMethod = "GET" // здесь можно указать HTTP метод — по умолчанию он GET
           request.allHTTPHeaderFields = [:] // а тут хедеры
           request.httpBody = nil // а здесь тело запроса
        */
        
        request.httpBody = Data() // тело запроса
        request.httpMethod = "POST" // имя HTTP метода
        request.setValue("test", forHTTPHeaderField: "TEST") // название заголовка
        
        // Создаем задачу на отправление запроса в сеть
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) {data, response, error in
            // здесь мы обрабатываем ответ от сервера
                   
            // data — данные от сервера
            // response — ответ от сервера, содержащий код ответа, хедеры и другую информацию об ответе
            // error — ошибка ответа, если что-то пошло не так
        }
        // Отправляем запрос
        task.resume()
        
    }
}

