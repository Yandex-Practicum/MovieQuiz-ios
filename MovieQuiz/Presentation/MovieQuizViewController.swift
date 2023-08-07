import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var noButton = UIButton()
    
    private var yesButton = UIButton()
    
    // MARK: Set count of correct answer to 0.
    private var correctAnswers: Int = 0
    
    // MARK: Set current question index to 0.
    private var currentQuestionIndex: Int = 0
    
    // MARK: Set array of question with mock-data.
    private var questions: [QuizQuestionModel] = [
        QuizQuestionModel(image: "The Godfather", correctAnswer: true),
        QuizQuestionModel(image: "The Dark Knight", correctAnswer: true),
        QuizQuestionModel(image: "Kill Bill", correctAnswer: true),
        QuizQuestionModel(image: "The Avengers", correctAnswer: true),
        QuizQuestionModel(image: "Deadpool", correctAnswer: true),
        QuizQuestionModel(image: "The Green Knight", correctAnswer: true),
        QuizQuestionModel(image: "Old", correctAnswer: false),
        QuizQuestionModel(image: "The Ice Age Adventures of Buck Wild", correctAnswer: false),
        QuizQuestionModel(image: "Tesla", correctAnswer: false),
        QuizQuestionModel(image: "Vivarium", correctAnswer: false),
        QuizQuestionModel(image: "The Lord Of The Rings", correctAnswer: true),
        QuizQuestionModel(image: "The Room", correctAnswer: false),
    ]
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Constants.Fonts.ysDisplayFont(named: "Bold", size: 23.0)
        label.textColor = Constants.Colors.white
        return label
    }()
    
    private var quizFilmImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = Constants.Colors.white
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    private var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вопрос:"
        label.font = Constants.Fonts.ysDisplayFont(named: "Medium", size: 20.0)
        label.textColor = Constants.Colors.white
        return label
    }()
    
    private var indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/10"
        label.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        label.font = Constants.Fonts.ysDisplayFont(named: "Medium", size: 20.0)
        label.textColor = Constants.Colors.white
        return label
    }()
    
    // MARK: Setup horizontal stack which containts two buttons (yes, no).
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: Setup horizontal stack which containts question title and index title.
    private var questionTitlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: Setup vertical stack view which containts all views on the screen.
    private var generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: Setup view which containts question label for create special constraints for presenting on the screen.
    private var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layoutConstraints()
        
        let question = convertQuestionToStepViewModel(to: questions[currentQuestionIndex])
        showQuestion(quiz: question)
    }
    
    private func setupView() {
        // MARK: Setup background.
        view.backgroundColor = Constants.Colors.background
        
        // MARK: Setup buttons.
        setupButtons(with: noButton, "Нет")
        setupButtons(with: yesButton, "Да")
        
        // MARK: Adding subviews into container and stack views.
        viewContainer.addSubview(questionLabel)
        
        buttonsStackView.addArrangedSubview(noButton)
        buttonsStackView.addArrangedSubview(yesButton)
        
        questionTitlesStackView.addArrangedSubview(questionTitleLabel)
        questionTitlesStackView.addArrangedSubview(indexLabel)
        
        generalStackView.addArrangedSubview(questionTitlesStackView)
        generalStackView.addArrangedSubview(quizFilmImage)
        generalStackView.addArrangedSubview(viewContainer)
        generalStackView.addArrangedSubview(buttonsStackView)
        
        view.addSubview(generalStackView)
    }
    
    // MARK: Private func which setup two same buttons.
    private func setupButtons(with button: UIButton, _ title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.Colors.white
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Constants.Fonts.ysDisplayFont(named: "Medium", size: 20.0)
        button.setTitleColor(Constants.Colors.black, for: .normal)
        button.layer.cornerRadius = 15
        
        if (title == "Да") {
            button.addTarget(self, action: #selector(yesButtonTapHandler), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(noButtonTapHandler), for: .touchUpInside)
        }
    }
    
    // MARK: Private func which setup all constrains.
    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            questionLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 13),
            questionLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 42),
            questionLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -42),
            questionLabel.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -13),
            quizFilmImage.heightAnchor.constraint(equalTo: generalStackView.heightAnchor, multiplier: 2.0 / 3.0),
            
            noButton.widthAnchor.constraint(equalToConstant: 157),
            noButton.heightAnchor.constraint(equalToConstant: 60),
            yesButton.widthAnchor.constraint(equalToConstant: 157),
            yesButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func yesButtonTapHandler() {
        setEnabledButtons(to: false)
        let currentQuestion = questions[currentQuestionIndex]
        
        showAnswerResult(true == currentQuestion.correctAnswer)
    }
    
    @objc private func noButtonTapHandler() {
        setEnabledButtons(to: false)
        let currentQuestion = questions[currentQuestionIndex]
        
        showAnswerResult(false == currentQuestion.correctAnswer)
    }
    
    // MARK: Private func which hide second touch on buttons.
    private func setEnabledButtons(to value: Bool) {
        noButton.isEnabled = value
        yesButton.isEnabled = value
    }
    
    private func convertQuestionToStepViewModel(to quizQuestionModel: QuizQuestionModel) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: quizQuestionModel.image) ?? UIImage(), question: quizQuestionModel.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        quizFilmImage.image = step.image
        quizFilmImage.layer.borderWidth = 0
        quizFilmImage.layer.borderColor = Constants.Colors.black?.cgColor
        
        indexLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    // MARK: Override property which set style for StatusBar.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func showNextQuestionOrResult() {
        if (currentQuestionIndex == questions.count - 1) {
            let correctAnswersText = "Ваш результат: \(correctAnswers)/\(questions.count)"
            showAlertResult(quiz: QuizResultViewModel(title: "Этот раунд окончен!", currentAnswersLabel: correctAnswersText, buttonText: "Сыграть ещё раз"))
        } else {
            setEnabledButtons(to: true)
            currentQuestionIndex += 1
            
            let question = convertQuestionToStepViewModel(to: questions[currentQuestionIndex])
            
            showQuestion(quiz: question)
        }
    }
    
    private func showAlertResult(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title, message: result.currentAnswersLabel, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let question = self.convertQuestionToStepViewModel(to: self.questions[self.currentQuestionIndex])
            self.showQuestion(quiz: question)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(_ isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
        quizFilmImage.layer.masksToBounds = true
        quizFilmImage.layer.borderWidth = 8
        quizFilmImage.layer.borderColor = isCorrect ? Constants.Colors.green?.cgColor : Constants.Colors.red?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
        }
    }
}
