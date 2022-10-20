import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Creating glabal variables
    private var currentQuestionIndex = 0
    private var correctAnswersToQuestions = 0
    private var numberOfRoundsPlayed = 0
    private var resultsOfEachPlayedRound: [(maxResult: Int, date: String)] = []
   
    
    // MARK: - Creating all UIViews for screen
    private let questionTitleLabel: UILabel = {
        let questionTopLabe = UILabel()
        questionTopLabe.textColor = .ypWhite
        questionTopLabe.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTopLabe.translatesAutoresizingMaskIntoConstraints = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.02
        questionTopLabe.attributedText =
        NSMutableAttributedString(string: "Вопрос:",
                                  attributes: [
                                    NSAttributedString.Key.kern: 0.38,
                                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                                  ])
        return questionTopLabe
    }()
    
    private let indexLabel: UILabel = {
        let indexLab = UILabel()
        indexLab.textColor = .ypWhite
        indexLab.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLab.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        indexLab.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.02
        indexLab.attributedText =
        NSMutableAttributedString(string: "1/10",
                                  attributes: [
                                    NSAttributedString.Key.kern: 0.38,
                                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                                  ])
        return indexLab
    }()
    
    private let previewImage: UIImageView = {
       let previewImg = UIImageView(image: UIImage())
        
        previewImg.contentMode = .scaleAspectFill
        previewImg.backgroundColor = .ypWhite
        previewImg.translatesAutoresizingMaskIntoConstraints = false
        previewImg.layer.masksToBounds = true
        previewImg.layer.cornerRadius = 20
        return previewImg
    }()
    
    private let questionLabel: UILabel = {
        let questionLab = UILabel()
        questionLab.textColor = .ypWhite
        questionLab.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLab.numberOfLines = 2
        questionLab.setContentCompressionResistancePriority(UILayoutPriority(751.0), for: .vertical)
        questionLab.textAlignment = .center
        questionLab.translatesAutoresizingMaskIntoConstraints = false
        questionLab.text = "Рэйтинг этого фильма меньше чем 5?"

        return questionLab
    }()
    
    private let viewForQuestionLabel: UIView = {
        let viewForLab = UIView()
        
        return viewForLab
    }()
    
    // I use lazy because of function in selector
    lazy private var nooButton: UIButton = {
        let noButton = UIButton(type: .system)
        noButton.backgroundColor = .ypGray
        noButton.layer.cornerRadius = 15
        noButton.setAttributedTitle(NSMutableAttributedString(string: "Нет", attributes: [NSAttributedString.Key.kern: 0.38]), for: .normal)
        noButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.setTitleColor(.ypBlack, for: .normal)
        noButton.titleLabel?.textAlignment = .center
        
       
        noButton.addTarget(self, action: #selector(nooButtonPressed(sender: )), for: .touchUpInside)
        noButton.translatesAutoresizingMaskIntoConstraints = false
        return noButton
    }()
    
    // I use lazy because of function in selector
    lazy private var yesButton: UIButton = {
        let yeButton = UIButton(type: .system)
        yeButton.backgroundColor = .ypGray
        yeButton.layer.cornerRadius = 15
        yeButton.setAttributedTitle(NSMutableAttributedString(string: "Да", attributes: [NSAttributedString.Key.kern: 0.38]), for: .normal)
        yeButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        yeButton.setTitleColor(.ypBlack, for: .normal)
        yeButton.titleLabel?.textAlignment = .center
        yeButton.addTarget(self, action: #selector(yesButtonPressed(sender: )), for: .touchUpInside)
        yeButton.translatesAutoresizingMaskIntoConstraints = false
        return yeButton
    }()
    
    private let stackViewForButtons: UIStackView = {
        let stackViewForBut = UIStackView()
        stackViewForBut.axis = NSLayoutConstraint.Axis.horizontal
        stackViewForBut.distribution = .fillEqually
        stackViewForBut.alignment = .fill
        stackViewForBut.spacing = 20
        stackViewForBut.translatesAutoresizingMaskIntoConstraints = false
        return stackViewForBut
    }()
    
    private let stackViewForLabels: UIStackView = {
        let stackViewForLab = UIStackView()
        stackViewForLab.axis = NSLayoutConstraint.Axis.horizontal
        stackViewForLab.distribution = .fill
        stackViewForLab.alignment = .fill
        stackViewForLab.spacing = 0
        stackViewForLab.translatesAutoresizingMaskIntoConstraints = false
        
        return stackViewForLab
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
        
        view.backgroundColor = .black
        throwAllElementsOnScreen()
        createConstraints()
        
        show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
    }
    
    // set all views in one function
    private func throwAllElementsOnScreen() {
        
        stackViewForLabels.addArrSubViews(questionTitleLabel,
                                          indexLabel)
        stackViewForButtons.addArrSubViews(nooButton,
                                           yesButton)
        viewForQuestionLabel.addSubview(questionLabel)
    
        stackViewForAll.addArrSubViews(stackViewForLabels,
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
        nooButton.heightAnchor.constraint(equalToConstant: 60),
        
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
    
    
    // MARK: - All nessesary structs for logic of the game
    struct QuizQuestion {
        // struct for mock data we use
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    struct QuizStepViewModel {
        // struct to fill up nessesary fields on main game screen
        let question: String
        let image: UIImage
        let questionNumber: String
    }
    struct QuizResultViewModel {
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
        
        let corectAnswer = quizQuestions[currentQuestionIndex].correctAnswer
        if isCorrect == corectAnswer {
            (previewImage.layer.borderColor = UIColor.ypGreen.cgColor)
            correctAnswersToQuestions += 1
        } else {
            (previewImage.layer.borderColor = UIColor.ypRed.cgColor)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResult()
        }
    }
    
    private func show(quiz result: QuizResultViewModel) {
       
        let alert = UIAlertController(title: result.label,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) { _ in
            
            self.currentQuestionIndex = 0
            self.correctAnswersToQuestions = 0
            // show main screen again using show and convert functions and mock data when alert button touched
            self.show(quiz: self.convert(model: self.quizQuestions[self.currentQuestionIndex]))
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
                                            Рекорд: \(showPesronalBestResult())
                                            Средняя точность: \(String(format: "%.2f", calculateAccuracy()))%
                                            """,
                                           buttonText: "Сыграть еще раз"))
           
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: quizQuestions[currentQuestionIndex]))
        }
    }
    
    func showPesronalBestResult() -> String {
         
        let maxResult = resultsOfEachPlayedRound
            .map { $0.maxResult } // transform array from tuple to array of numbers
            .max() // get the max number
        
        // get the array of String with our result in good appearence
        let recordInfo: [String?] = resultsOfEachPlayedRound
            .filter { $0.maxResult == maxResult }
            .map { i in
                "\(i.maxResult)/\(quizQuestions.count) (\(i.date))"
            }
        // get data from array
        guard let infoExist = recordInfo[0] else {
            return "this case impossible"
        }
        
        return infoExist
    }
    
    func calculateAccuracy() -> Float {
        let accuracy = resultsOfEachPlayedRound
            .map { $0.maxResult }
            .reduce(0) { (i, j) in
                return i + j
            }
        return Float(accuracy * 100) / Float(quizQuestions.count * numberOfRoundsPlayed)
    }
    
    // buttons action
    @objc func nooButtonPressed(sender: UIButton) {
       
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
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.topAnchor
    }
    return topAnchor
  }

  var safeLeadingAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
        return safeAreaLayoutGuide.leadingAnchor
    }
    return leadingAnchor
}

  var safeTrailingAnchor: NSLayoutXAxisAnchor {
    if #available(iOS 11.0, *){
    return safeAreaLayoutGuide.trailingAnchor
    }
    return leftAnchor
}

  var safeBottomAnchor: NSLayoutYAxisAnchor {
    if #available(iOS 11.0, *) {
      return safeAreaLayoutGuide.bottomAnchor
    }
    return bottomAnchor
  }
 
}

extension UIStackView {
    // extension to add multiple arranged subviews (as Variadic parametrs)
    func addArrSubViews( _ arrViews: UIView...) {
        for arrView in arrViews {
            addArrangedSubview(arrView)
        }
    }
}


    


