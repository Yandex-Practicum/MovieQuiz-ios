import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    
    // MARK: - UI
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var questCountStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .equalSpacing
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 20
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var questionTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Вопрос:"
        element.font = UIFont(name: "YSDisplay-Medium", size: 20)
        element.textColor = .ypWhite
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var counterLabel: UILabel = {
        let element = UILabel()
        element.text = "\(currentQuestionIndex + 1)/10"
        element.font = UIFont(name: "YSDisplay-Medium", size: 20)
        element.textColor = .ypWhite
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Deadpool")
        element.layer.cornerRadius = 20
        element.layer.masksToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var textLabel: UILabel = {
        let element = UILabel()
        element.text = "Рейтинг этого фильма \nменьше чем 5?"
        element.numberOfLines = 0
        element.font = UIFont(name: "YSDisplay-Bold", size: 23)
        element.textColor = .ypWhite
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var noButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Нет", for: .normal)
        element.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        element.tintColor = .ypBlack
        element.layer.cornerRadius = 15
        element.backgroundColor = .ypWhite
        element.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var yesButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Да", for: .normal)
        element.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        element.tintColor = .ypBlack
        element.layer.cornerRadius = 15
        element.backgroundColor = .ypWhite
        element.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    // MARK: - Logic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        setView()
        setupConstraints()
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(questCountStackView)
        questCountStackView.addArrangedSubview(questionTitleLabel)
        questCountStackView.addArrangedSubview(counterLabel)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(textLabel)
        mainStackView.addArrangedSubview(buttonsStackView) //60
        buttonsStackView.addArrangedSubview(noButton)
        buttonsStackView.addArrangedSubview(yesButton)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            fatalError("no questions")
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let messageText = """
                              \nКоличество сыгранных квизов: \(statisticService.gamesCount)
                              Рекорд: \(bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))
                              Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                              """
        
        let alertModel = AlertModel(
            title: result.title,
            message: result.text + messageText,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else {
                    return
                }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.show(alert: alertModel)
    }
    
    @objc private func noButtonTapped() {
        noButton.isEnabled = false
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @objc private func yesButtonTapped() {
        yesButton.isEnabled = false
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        guard currentQuestionIndex + 1 < questionsAmount else {
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers) из 10",
                buttonText: "Сыграть ещё раз")
            show(quiz: result)
            return
        }
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }
}


// MARK: - Constraints

extension MovieQuizViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            questCountStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            questCountStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            questCountStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            questCountStackView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2.0 / 3.0),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            yesButton.heightAnchor.constraint(equalTo: buttonsStackView.heightAnchor),
            noButton.heightAnchor.constraint(equalTo: yesButton.heightAnchor),
            noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
        ])
    }
}





/*
 Mock-данные
 
 
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


