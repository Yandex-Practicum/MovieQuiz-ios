import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var noButton = UIButton()
    
    private var yesButton = UIButton()
    
    private var correctAnswers: Int = 0
    
    private var questionIndex: Int = 0
    
    
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
    
    
    private func convert(to quizQuiestion: QuizQuestionModel) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: quizQuiestion.image) ?? UIImage(), question: quizQuiestion.text, questionNumber: "\(questionIndex)/10")
    }
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Рейтинг этого фильма меньше чем X?"
        label.font = UIFont(name: "YSDisplay-Bold", size: 23.0)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private var quizFilmImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor(named: "YP White")
        image.layer.cornerRadius = 20
        return image
    }()
    
    private var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вопрос:"
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private var indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/10"
        label.setContentHuggingPriority(.init(rawValue: 252), for: .horizontal)
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var questionTitlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private var generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
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
    }
    
    private func setupView() {
        // MARK: Setup background.
        view.backgroundColor = UIColor(named: "YP Background")
        viewContainer.addSubview(questionLabel)
        
        setupButtons(with: noButton, "Нет")
        setupButtons(with: yesButton, "Да")
        
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
    
    private func setupButtons(with button: UIButton, _ title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "YP White")
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.layer.cornerRadius = 15
    }
    
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
}
