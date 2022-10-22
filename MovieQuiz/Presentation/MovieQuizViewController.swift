import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Creating global variables
    private var currentQuestionIndex = 0
    private var correctAnswersToQuestions = 0
    private var numberOfRoundsPlayed = 0
    private var resultsOfEachPlayedRound: [(maxResult: Int, date: String)] = []
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Creating all UIViews for screen
    private let questionTitleLabel: UILabel = {
        let questionTopLabel = UILabel()
        questionTopLabel.textColor = .ypWhite
        questionTopLabel.font = .ysMedium
        questionTopLabel.translatesAutoresizingMaskIntoConstraints = false
        questionTopLabel.text = "Вопрос:"
        
        return questionTopLabel
    }()
    
    private let indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.textColor = .ypWhite
        indexLabel.font = .ysMedium
        indexLabel.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.text = "1/10"
        
        return indexLabel
    }()
    
    private let previewImage: UIImageView = {
       let previewImage = UIImageView(image: UIImage())
        
        previewImage.contentMode = .scaleAspectFill
        previewImage.backgroundColor = .ypWhite
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.layer.masksToBounds = true
        previewImage.layer.cornerRadius = 20
        return previewImage
    }()
    
    private let questionLabel: UILabel = {
        let questionLabel = UILabel()
        questionLabel.textColor = .ypWhite
        questionLabel.font = .ysBold
        questionLabel.numberOfLines = 2
        questionLabel.setContentCompressionResistancePriority(UILayoutPriority(751.0), for: .vertical)
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = "Рэйтинг этого фильма меньше чем 5?"

        return questionLabel
    }()
    
    private let viewForQuestionLabel = UIView()
   
    // I use lazy because of function in selector
    lazy private var noButton: UIButton = {
        let noButton = UIButton(type: .system)
        noButton.backgroundColor = .ypGray
        noButton.layer.cornerRadius = 15
        noButton.setTitle("Нет", for: .normal)
        noButton.titleLabel?.font =  .ysMedium
        noButton.setTitleColor(.ypBlack, for: .normal)
        noButton.titleLabel?.textAlignment = .center
        
       
        noButton.addTarget(self, action: #selector(noButtonPressed(sender: )), for: .touchUpInside)
        noButton.translatesAutoresizingMaskIntoConstraints = false
        return noButton
    }()
    
    // I use lazy because of function in selector
    lazy private var yesButton: UIButton = {
        let yeButton = UIButton(type: .system)
        yeButton.backgroundColor = .ypGray
        yeButton.layer.cornerRadius = 15
        yeButton.setTitle("Да", for: .normal)
        yeButton.titleLabel?.font =  .ysMedium
        yeButton.setTitleColor(.ypBlack, for: .normal)
        yeButton.titleLabel?.textAlignment = .center
        yeButton.addTarget(self, action: #selector(yesButtonPressed(sender: )), for: .touchUpInside)
        yeButton.translatesAutoresizingMaskIntoConstraints = false
        return yeButton
    }()
    
    private let stackViewForButtons: UIStackView = {
        let stackViewForButtons = UIStackView()
        stackViewForButtons.axis = NSLayoutConstraint.Axis.horizontal
        stackViewForButtons.distribution = .fillEqually
        stackViewForButtons.alignment = .fill
        stackViewForButtons.spacing = 20
        stackViewForButtons.translatesAutoresizingMaskIntoConstraints = false
        return stackViewForButtons
    }()
    
    private let stackViewForLabels: UIStackView = {
        let stackViewForLabels = UIStackView()
        stackViewForLabels.axis = NSLayoutConstraint.Axis.horizontal
        stackViewForLabels.distribution = .fill
        stackViewForLabels.alignment = .fill
        stackViewForLabels.spacing = 0
        stackViewForLabels.translatesAutoresizingMaskIntoConstraints = false
        
        return stackViewForLabels
    }()
    
    private let stackViewForAll: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        throwAllElementsOnScreen()
        createConstraints()
        
        show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
    }
    
    // set all views in one function
    private func throwAllElementsOnScreen() {
        
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
    
    
    // MARK: - Creating all Constraints
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
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            noButton.isEnabled = true
            yesButton.isEnabled = true
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
            // Append array to save data such as accuracy, best result and time
            resultsOfEachPlayedRound.append((maxResult: correctAnswersToQuestions,
                                             date: Date().dateTimeString))
            
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
    
    func showPersonalBestResult() -> String {
         
        let maxResult = resultsOfEachPlayedRound
            .map { $0.maxResult } // transform array from tuple to array of numbers
            .max() // get the max number
        
        // get the array of String with our result in good appearance
        let recordInfo: [String?] = resultsOfEachPlayedRound
            .filter { $0.maxResult == maxResult }
            .map { "\($0.maxResult)/\(quizQuestions.count) (\($0.date))"}
        
        // get data from array
        guard let infoExist = recordInfo[0] else {
            return "this case impossible"
        }
        
        return infoExist
    }
    
    func calculateAccuracy() -> Float {
        let accuracy = resultsOfEachPlayedRound
            .map { $0.maxResult }
            .reduce(0, +)
        return Float(accuracy * 100) / Float(quizQuestions.count * numberOfRoundsPlayed)
    }
    
    // buttons action
    @objc func noButtonPressed(sender: UIButton) {
       
        showAnswerResult(isCorrect: false)
    }
    @objc func yesButtonPressed(sender: UIButton) {
       
        showAnswerResult(isCorrect: true)
    }
    
    // array of QuizQuestion type for main game screen
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
