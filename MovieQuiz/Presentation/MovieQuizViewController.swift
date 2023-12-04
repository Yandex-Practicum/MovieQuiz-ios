import UIKit

class MovieQuizViewController: UIViewController {
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    
    // MARK: - UI
    
    private lazy var yStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(questionXStackView)
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(questionTitleLabel)
        stackView.addArrangedSubview(buttonStackView)
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var questionXStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(currentQuestionAndQuestionsAmountLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вопрос:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let currentQuestionAndQuestionsAmountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 6
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(noButton)
        stackView.addArrangedSubview(yesButton)
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Да", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        button.backgroundColor = .white
        button.isEnabled = false
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        
        questionFactory = QuestionFactory(delegate: self)
//        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        
        alertPresenter = AlertPresenter(controller: self)
        
        statisticService = StatisticServiceImplementation()
        
    }
    
    private func addSubviews() {
        let subViews = [yStackView]
        subViews.forEach(view.addSubview)
        view.addSubview(activityIndicatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            yStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            yStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            yStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            questionXStackView.topAnchor.constraint(equalTo: yStackView.topAnchor),
            questionXStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionXStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            currentQuestionAndQuestionsAmountLabel.trailingAnchor.constraint(equalTo: questionXStackView.trailingAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 674),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func show(quiz step: QuizStepViewModel) {
        questionTitleLabel.text = step.question
        currentQuestionAndQuestionsAmountLabel.text = step.questionNumber
        posterImageView.image = step.image
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
        
      private func showNextAnswerOrResult() {
            if currentQuestionIndex == questionsAmount - 1 {
                guard let statisticService else { return }
                statisticService.store(correct: correctAnswers, total: questionsAmount)
                let text = """
                
                Ваш результат: \(correctAnswers)/10
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/10 \(statisticService.bestGame.date)
                Средняя точность \(statisticService.totalAccuracy)
                
                """
                    
                let alertModel = AlertModel(
                    title: "Этот раунд окончен!",
                    message: text,
                    buttonText: "Сыграть ещё раз",
                    completion: nil
                )
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                alertPresenter?.show(result: alertModel)
            } else {
                currentQuestionIndex += 1
                questionFactory?.requestNextQuestion()
            }
        }
        
        private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
            
            posterImageView.layer.masksToBounds = true
            posterImageView.layer.borderWidth = 8
            posterImageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self else { return }
                self.showNextAnswerOrResult()
                posterImageView.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showLoadingIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicatorView.isHidden = true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз?") { [weak self] in
            guard let self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(result: model)
    }
    
    //MARK: -Actions
    @objc func noButtonTapped() {
        guard let currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @objc func yesButtonTapped() {
        guard let currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

//MARK: - QuestionFactoryDelegate

extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
