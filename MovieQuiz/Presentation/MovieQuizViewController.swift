import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Global variables
    private var currentQuestionIndex: Int8 = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var currentQuestion: QuizQuestion?
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Dependencies
    private var questionsFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    
    // MARK: - UIElements
    private var questionTitleLabel = UILabel()
    private let indexLabel = UILabel()
    private let questionLabel = UILabel()
    private let viewForQuestionLabel = UIView()
    private var noButton = UIButton(type: .system)
    private var yesButton = UIButton(type: .system)
    private let previewImage: UIImageView = {
       let previewImage = UIImageView(image: UIImage())
        previewImage.contentMode = .scaleAspectFill
        previewImage.backgroundColor = .ypWhite
        previewImage.layer.masksToBounds = true
        previewImage.layer.cornerRadius = 20
        return previewImage
    }()
    private let activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        return activityIndicator
    }()

    private let stackViewForButtons = UIStackView()
    private let stackViewForLabels = UIStackView()
    private let stackViewForAll = UIStackView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        alertPresenter = AlertPresenter(movieQuizViewController: self)
        questionsFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        statisticService = StatisticServiceImplementation()
        throwAllElementsOnScreen()
        
        createConstraints()
        questionsFactory?.loadData()
        questionsFactory?.requestNextQuestion()
        showLoadingIndicator()
       
    }
    
    // MARK: - makeAppearanceOfAllElements and Create all Constraints
    private func makeAppearanceOfAllElements() {
        view.backgroundColor = .ypBlack
        
        makeAppearance(of: noButton, title: "Нет", action: #selector(noButtonPressed(sender: )))
        makeAppearance(of: yesButton, title: "Да", action: #selector(yesButtonPressed(sender: )))
        
        makeAppearance(of: questionTitleLabel, text: "Вопрос:", font: .ysMedium ?? UIFont())
        
        makeAppearance(of: indexLabel, text: "1/10", font: .ysMedium ?? UIFont(), textAlignment: .right)
        indexLabel.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        
        makeAppearance(of: questionLabel, text: "Рэйтинг этого фильма больше чем 5?", font: .ysBold ?? UIFont(), numberOfLines: 2, textAlignment: .center)
        
        questionLabel.setContentCompressionResistancePriority(UILayoutPriority(751.0), for: .vertical)
        
        makeAppearance(of: stackViewForLabels, axis: .horizontal, distribution: .fill, spacing: 0)
        makeAppearance(of: stackViewForButtons, axis: .horizontal, distribution: .fillEqually)
        makeAppearance(of: stackViewForAll, axis: .vertical, distribution: .fill)
    }
    private func createConstraints() {
        
        NSLayoutConstraint.activate([
            
        // set constraints for (stackViewForAll)
        stackViewForAll.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor,
                                                 constant: 20),
        stackViewForAll.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor,
                                                  constant: -20),
        stackViewForAll.topAnchor.constraint(equalTo: view.safeTopAnchor,
                                             constant: 10),
        stackViewForAll.bottomAnchor.constraint(equalTo: view.safeBottomAnchor,
                                                constant: 0),
        
        // set ratio for (previewImage) 2/3
        previewImage.widthAnchor.constraint(equalTo: previewImage.heightAnchor,
                                            multiplier: (2/3)),
        
        // set height for stackViewForButtons
        stackViewForButtons.heightAnchor.constraint(equalToConstant: 60),
        
        // set  constraints from label to view, label sits inside
        questionLabel.leadingAnchor.constraint(equalTo: viewForQuestionLabel.leadingAnchor,
                                               constant: 42),
        questionLabel.trailingAnchor.constraint(equalTo:viewForQuestionLabel.trailingAnchor,
                                                constant: -42),
        questionLabel.topAnchor.constraint(equalTo: viewForQuestionLabel.topAnchor,
                                           constant: 13),
        questionLabel.bottomAnchor.constraint(equalTo: viewForQuestionLabel.bottomAnchor,
                                              constant: -13),
        // activityIndicator
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        ])
    }
    private func throwAllElementsOnScreen() {
        
        makeAppearanceOfAllElements()
        
        [noButton,yesButton,indexLabel,questionLabel,questionTitleLabel,previewImage,
         stackViewForAll,stackViewForLabels,stackViewForButtons,activityIndicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        
        stackViewForLabels.addArrangedSubViews(questionTitleLabel,
                                          indexLabel)
        stackViewForButtons.addArrangedSubViews(noButton,
                                           yesButton)
        viewForQuestionLabel.addSubview(questionLabel)
    
        stackViewForAll.addArrangedSubViews(stackViewForLabels,
                                       previewImage,
                                       viewForQuestionLabel,
                                       stackViewForButtons)
        
        
        view.addSubview(stackViewForAll)
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Functions to handle "state machine"
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(question: model.text,
                                 image: UIImage(data: model.image) ?? UIImage(),
                                 questionNumber:
                                    "\(currentQuestionIndex+1)/\(questionsAmount)")
    }
    //gets called after each press of button through factory
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        previewImage.layer.borderWidth = 8
        let correctAnswer = currentQuestion?.correctAnswer
        
        if isCorrect == correctAnswer {
            previewImage.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            previewImage.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        [noButton,yesButton].forEach { $0.isEnabled.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            [self.noButton,self.yesButton].forEach { $0.isEnabled.toggle() }
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        previewImage.layer.borderWidth = 0
        previewImage.layer.borderColor = nil
        
        if currentQuestionIndex == (questionsAmount - 1) {
            createDataForAlertPresenter()
            
        } else {
            currentQuestionIndex += 1
            questionsFactory?.requestNextQuestion()
            
        }
    }
    
    private func createDataForAlertPresenter() {
        guard let statisticService = statisticService else {return}
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let dateAndTime = statisticService.bestGame.date.dateTimeString
        
        let endOfRoundAlert =
        AlertModel(title: "Этот раунд окончен!",
                 message: """
                  Ваш результат: \(correctAnswers)/\(questionsAmount)
                  Количество сыгранных квизов: \(statisticService.gamesCount)
                  Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(dateAndTime))
                  Средняя точность: \(statisticService.totalAccuracy.myOwnRounded)%
                  """,
                 buttonText: "Сыграть еще раз") { [weak self] in
            
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionsFactory?.requestNextQuestion()
        }
        alertPresenter?.displayAlert(endOfRoundAlert)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    // buttons action
    @objc private func noButtonPressed(sender: UIButton) {
        showAnswerResult(isCorrect: false)
    }
    @objc private func yesButtonPressed(sender: UIButton) {
        showAnswerResult(isCorrect: true)
    }
}

// Functions to create Labels, Buttons, StackViews
extension MovieQuizViewController {
    
    private func makeAppearance(of button: UIButton, title: String, font: UIFont = .ysMedium ?? UIFont(),
                                alignment: NSTextAlignment = .center, backgroundColor: UIColor = .ypGray,
                                titleColor: UIColor = .ypBlack, cornerRadius: CGFloat = 15,
                                action: Selector) {
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.setTitle(title, for: .normal)
        button.titleLabel?.font =  font
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    private func makeAppearance(of label: UILabel, text: String, textColor: UIColor = .ypWhite, font: UIFont,
                                numberOfLines: Int = 0, textAlignment: NSTextAlignment? = .none) {
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment ?? .natural
    }
    private func makeAppearance(of stackView: UIStackView, axis: NSLayoutConstraint.Axis,
                                distribution: UIStackView.Distribution,
                                alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 20) {
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didFailedToLoadImage() {
        print("ppppp")
        showLoadingIndicator()
    }
    
    
    func didLoadDataFromServer() {
        
        activityIndicator.isHidden = true
        questionsFactory?.requestNextQuestion()
        
    }
    
    func didFailToLoadDataFromServer(with error: Error) {
        
        alertPresenter?.displayAlert(AlertModel(title: "Ошибка",
                                                message: error.localizedDescription,
                                                buttonText: "Попробовать еще раз",
                                                completion: { [weak self] in
            self?.showLoadingIndicator()
            self?.questionsFactory?.requestNextQuestion()
            self?.questionsFactory?.loadData()
        }))
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        activityIndicator.isHidden = true
        print("BBB")
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}

