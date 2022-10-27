import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Creating global variables
    private var currentQuestionIndex = 0
    private var correctAnswersToQuestions = 0
    private var numberOfRoundsPlayed = 0
    private var resultsOfEachPlayedRound = [Int:String]()
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - UIElements
    private let questionTitleLabel = UILabel()
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

    private let stackViewForButtons = UIStackView()
    private let stackViewForLabels = UIStackView()
    private let stackViewForAll = UIStackView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        throwAllElementsOnScreen()
        createConstraints()
        show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
    }
    
    // MARK: - Creating all Constraints
    private func makeAppearanceOfAllElements() {
        
        makeAppearance(of: noButton, title: "Нет", action: #selector(noButtonPressed(sender: )))
        makeAppearance(of: yesButton, title: "Да", action: #selector(yesButtonPressed(sender: )))
        
        makeAppearance(of: questionTitleLabel, text: "Вопрос:", font: .ysMedium ?? UIFont())
        
        makeAppearance(of: indexLabel, text: "1/10", font: .ysMedium ?? UIFont(), textAlignment: .right)
        indexLabel.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        
        makeAppearance(of: questionLabel, text: "Рэйтинг этого фильма меньше чем 5?", font: .ysBold ?? UIFont(),
                       numberOfLines: 2, textAlignment: .center)
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
        
        // set height for buttons
        noButton.heightAnchor.constraint(equalToConstant: 60),
        
        // set  constraints from label to view, label sits inside
        questionLabel.leadingAnchor.constraint(equalTo: viewForQuestionLabel.leadingAnchor,
                                               constant: 42),
        questionLabel.trailingAnchor.constraint(equalTo:viewForQuestionLabel.trailingAnchor,
                                                constant: -42),
        questionLabel.topAnchor.constraint(equalTo: viewForQuestionLabel.topAnchor,
                                           constant: 13),
        questionLabel.bottomAnchor.constraint(equalTo: viewForQuestionLabel.bottomAnchor,
                                              constant: -13)
        
        ])
    }
    private func throwAllElementsOnScreen() {
        
        makeAppearanceOfAllElements()
        
        [noButton,yesButton,indexLabel,questionLabel,questionTitleLabel,previewImage,
         stackViewForAll,stackViewForLabels,stackViewForButtons].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        
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
    }
    
    // MARK: - Functions to handle "state machine"
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(question: model.text,
                                 image: UIImage(named: model.image) ?? UIImage(),
                                 questionNumber: "\(currentQuestionIndex+1)/\(quizQuestions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        indexLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        previewImage.layer.cornerRadius = 20
        previewImage.layer.borderWidth = 8
        
        let correctAnswer = quizQuestions[currentQuestionIndex].correctAnswer
        if isCorrect == correctAnswer {
            (previewImage.layer.borderColor = UIColor.ypGreen.cgColor)
            correctAnswersToQuestions += 1
        } else {
            (previewImage.layer.borderColor = UIColor.ypRed.cgColor)
        }
        
        [noButton,yesButton].forEach { $0.isEnabled.toggle() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            [noButton,yesButton].forEach { $0.isEnabled.toggle() }
            showNextQuestionOrResult()
        }
    }
    
    private func show(quiz result: QuizResultViewModel) {
       
        let alert = UIAlertController(title: result.label,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) { [self] _ in
            currentQuestionIndex = 0
            correctAnswersToQuestions = 0
            // show main screen again using show and convert functions and mock data when alert button touched
            show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
        quizQuestions.shuffle()
    }
    
    private func showNextQuestionOrResult() {
        
        previewImage.layer.borderWidth = 0
        previewImage.layer.borderColor = nil
        
        if currentQuestionIndex == (quizQuestions.count - 1) {
            
            numberOfRoundsPlayed += 1
            
            // Append Dict to save data such as best result and time
            resultsOfEachPlayedRound.updateValue(Date().dateTimeString, forKey: correctAnswersToQuestions)
            
            show(quiz: QuizResultViewModel(label: "Этот раунд окончен!",
                                           text: """
                                            Ваш результат: \(correctAnswersToQuestions)/\(quizQuestions.count)
                                            Количество сыгранных квизов: \(numberOfRoundsPlayed)
                                            Рекорд: \(showPersonalBestResult())
                                            Средняя точность: \(String(format: "%.2f", calculateAccuracy()))%
                                            """,
                                           buttonText: "Сыграть еще раз"))
           
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
        }
    }
    
    private func showPersonalBestResult() -> String {
         
        let maxResultAndTime = resultsOfEachPlayedRound
            .max { $0.key < $1.key }
        
        guard let maxResultAndTime = maxResultAndTime else {return "NIL"}
        
        return "\(maxResultAndTime.key)/\(quizQuestions.count) (\(maxResultAndTime.value))"
    }
   
    private func calculateAccuracy() -> Float {
        
        let sumOfMaxResultsOfAllRounds = resultsOfEachPlayedRound.keys.reduce(0, +)
        return Float(sumOfMaxResultsOfAllRounds * 100) / Float(quizQuestions.count * numberOfRoundsPlayed)
    }
    
    // buttons action
    @objc func noButtonPressed(sender: UIButton) {
        showAnswerResult(isCorrect: false)
    }
    @objc func yesButtonPressed(sender: UIButton) {
        showAnswerResult(isCorrect: true)
    }
    
    // MARK: - All necessary structs for logic of the game
    private struct QuizQuestion {
        // struct for mock data we use
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    private struct QuizStepViewModel {
        // struct to fill up necessary fields on main game screen
        let question: String
        let image: UIImage
        let questionNumber: String
    }
    private struct QuizResultViewModel {
        let label: String
        let text: String
        let buttonText: String
    }
    private var quizQuestions = [
        QuizQuestion(image: "The Godfather",
                  text: "Рейтинг этого фильма больше чем 9?",
                  correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                  text: "Рейтинг этого фильма больше чем 9?",
                  correctAnswer: false),
        QuizQuestion(image: "Kill Bill",
                  text: "Рейтинг этого фильма больше чем 8?",
                  correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                  text: "Рейтинг этого фильма больше чем 9?",
                  correctAnswer: false),
        QuizQuestion(image: "Deadpool",
                  text: "Рейтинг этого фильма больше чем 7?",
                  correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
        QuizQuestion(image: "Old",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
        QuizQuestion(image: "Tesla",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
    ]
}

extension UIView { // extension for safe area
  var safeTopAnchor: NSLayoutYAxisAnchor {
      return safeAreaLayoutGuide.topAnchor
  }
  var safeLeadingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
}
  var safeTrailingAnchor: NSLayoutXAxisAnchor {
    return safeAreaLayoutGuide.trailingAnchor
}
  var safeBottomAnchor: NSLayoutYAxisAnchor {
      return safeAreaLayoutGuide.bottomAnchor
  }
}

extension UIStackView {
    // extension to add multiple arranged subviews (as Variadic parameters)
    func addArrangedSubViews( _ arrangedViews: UIView...) {
        for arrangedView in arrangedViews {
            addArrangedSubview(arrangedView)
        }
    }
}

extension UIFont {
   static let ysMedium = UIFont(name: "YSDisplay-Medium", size: 20)
   static let ysBold = UIFont(name: "YSDisplay-Bold", size: 23)
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
        button.addTarget(self, action: #selector(noButtonPressed(sender: )), for: .touchUpInside)
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
