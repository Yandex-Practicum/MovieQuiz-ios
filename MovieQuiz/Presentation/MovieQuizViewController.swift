import UIKit

final class MovieQuizViewController: UIViewController {
    lazy var yesButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Да", for: .normal)
        $0.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .ypWhite
        $0.setTitleColor(.ypBlack, for: .normal)
        return $0
    }(UIButton(type: .system))
    
    lazy var noButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Нет", for: .normal)
        $0.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .ypWhite
        $0.setTitleColor(.ypBlack, for: .normal)
        return $0
    }(UIButton(type: .system))
    
    let questionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Вопрос:"
        $0.font = UIFont(name: "YS Display-Medium", size: 20)
        //        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    
    let indexLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "1/10"
        $0.font = UIFont(name: "YS Display-Medium", size: 20)
        //        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    
    let previewImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.borderWidth = 8
        $0.layer.cornerRadius = 20
        $0.layer.cornerCurve = .continuous
        $0.layer.allowsEdgeAntialiasing = true // сглаживанием краёв, они будут еще более четкими особенно ,если зазумить скриншот, без этого свойства если приблизить будут видны "пиксели" :)
        return $0
    }(UIImageView(image: UIImage(named: "preview")))
    
    let ratingLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Рейтинг этого фильма меньше чем 5?"
        $0.font = .preferredFont(forTextStyle: .title1) // ПРОШУ УЧЕСТЬ, ниже я указал font, как в макете, но он сильно отличается от того, что получилось в макете, а .preferredFont(forTextStyle: .title1) - сделал тоже самое что и
        //        $0.font = UIFont(name: "YS Display-Bold", size: 23)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .ypWhite
        return $0
    }(UILabel(frame: .zero))
    
    let buttonStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .fillEqually
        return $0
    }(UIStackView(frame: .zero))
    
    let labelStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 5, left: 0, bottom: 5, right: 0)
        return $0
    }(UIStackView(frame: .zero))
    
    let mainStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        return $0
    }(UIStackView(frame: .zero))
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // Предлагаем создать в нашем контроллере переменную, которая будет отвечать за индекс текущего вопроса:
    // При ответе на вопрос мы будем увеличивать этот счётчик и использовать
    // его для получения правильной модели из массива questions:
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    //    @IBOutlet weak var button: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContraints()
        //        let currentQuestion = questions[currentQuestionIndex]
        //        show(quiz: convert(model: currentQuestion))
    }
    
    // здесь мы заполняем нашу картинку, текст и счётчик данными
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = step.questionNumber
        previewImageView.image = step.image
    }
    
    // здесь мы показываем результат прохождения квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Конвертация — это преобразование.
    // В нашем случае — преобразование данных из одного формата в другой, то есть из QuizQuestion в QuizStepViewModel.
    // В этом случае мы преобразуем данные, которые есть в модели вопроса, в те данные, которые необходимо показать на этапе квиза.
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // А теперь давайте попробуем реализовать отображение красной или зелёной рамки, исходя из ответа:
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        previewImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
            self.showNextQuestionOrResults()
            self.previewImageView.layer.borderColor = nil
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
        }
    }
}


extension MovieQuizViewController {
    private func setupContraints() {
        view.addSubview(mainStackView)
        
        buttonStackView.addArrangedSubview(yesButton)
        buttonStackView.addArrangedSubview(noButton)
        
        labelStackView.addArrangedSubview(questionLabel)
        labelStackView.addArrangedSubview(indexLabel)
        
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(previewImageView)
        mainStackView.addArrangedSubview(ratingLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
        // отступ 33 от слов "Рейтинг этого фильма ... до кнопок ,как указано в макете
        mainStackView.setCustomSpacing(33, after: ratingLabel)
        // отступ 33 от картинки до слов "Рейтинг этого фильма ... ,как указано в макете
        mainStackView.setCustomSpacing(33, after: previewImageView)
        // отступ 20 от слова вопрос до картинки ,как указано в макете
        mainStackView.setCustomSpacing(20, after: labelStackView)
        questionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        previewImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical) // Сопротивление расширения, пригодится тогда когда картинка маленькая и тогда это свойство сможет расширить нашу картинку
        
        previewImageView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical) // Сопротивление сжатию, когда картинка большая он сможет её сжать
    }
    
     @objc func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
     @objc func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
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
