import UIKit

struct Movie {
    let id: Int
    let image: String
    let rating: Double
    let question: String
    let answer: String
}



final class MovieQuizViewController: UIViewController {
    
    private var currentMovie: Movie?
    
    private lazy var moviesCount = movies.count
    
    private var count = 0 //Count of valid answers
    
    private lazy var copyMovies = movies
    
    private var movies = [
        Movie.init(id: 1, image: "The Godfather", rating: 9.2, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "The Dark Knight", rating: 9, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "Kill Bill", rating: 8.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "The Avengers", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "Deadpool", rating: 8, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "The Green Knight", rating: 6.6, question: "Рейтинг этого фильма больше чем 6?", answer: "Да"),
        Movie.init(id: 1, image: "Old", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        Movie.init(id: 1, image: "The Ice Age Adventures of Buck Wild", rating: 4.3, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        Movie.init(id: 1, image: "Tesla", rating: 5.1, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет"),
        Movie.init(id: 1, image: "Vivarium", rating: 5.8, question: "Рейтинг этого фильма больше чем 6?", answer: "Нет")
        
    ]
    
    //MARK: - Business Logic
    
    private func restartGame() {
        
        moviesCount = movies.count //setup all questions
        
        copyMovies = movies //setup all movies in array
        
        count = 0 //count make null
        
        nextQuestion() //start 1 question
    }
    
    private func nextQuestion() {
        
        if copyMovies.isEmpty {
            
            let alert = UIAlertController(title: "Раунд окончен!", message: "Ваш результат: \(count)/10", preferredStyle: .alert)
            
            let continueAction = UIAlertAction.init(title: "Сыграть ещё раз", style: .default) { action in
                
                print(action, #line)
                self.restartGame()
            }
            
            alert.addAction(continueAction)
            present(alert, animated: true)
            return
        }
        
        scoreLabel.text = "\(moviesCount - copyMovies.count + 1)/\(moviesCount)"
        currentMovie = copyMovies.removeFirst()
        update()
    }
    
    //MARK: - UI States
    private func update() {
        
        if let question = currentMovie {
            
            posterImageView.layer.borderColor = UIColor.clear.cgColor
            posterImageView.layer.borderWidth = 0
            
            let image = UIImage(named: question.image)
            
            posterImageView.image = image
        }
    }
    
    //MARK: - Events
    @objc private func checkQuestionTapped(sender: UIButton) {
        
        if let buttonTitle = sender.titleLabel?.text {
            
            let movieTitle = currentMovie?.answer ?? ""
            print(buttonTitle, movieTitle)
            
            if buttonTitle == movieTitle {
                posterImageView.layer.borderColor = Colors.ypGreen.cgColor
                posterImageView.layer.borderWidth = 5
                
                count += 1
                
            } else {
                posterImageView.layer.borderColor = Colors.ypRed.cgColor
                posterImageView.layer.borderWidth = 5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextQuestion()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        nextQuestion()
    }
    
    //Closure init
    private let questionTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Вопрос:"
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = Colors.ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг этого фильма меньше чем 5?"
        label.font = UIFont(name: "YSDisplay-Bold", size: 23)
        label.textColor = Colors.ypWhite
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "1/10"
        label.font = UIFont(name: "YSDisplay-Medium", size: 20)
        label.textColor = Colors.ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет", for: .normal)
        button.setTitleColor(Colors.ypBlack, for: .normal)
        button.backgroundColor = Colors.ypWhite
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(checkQuestionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("Да", for: .normal)
        button.setTitleColor(Colors.ypBlack, for: .normal)
        button.backgroundColor = Colors.ypWhite
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(checkQuestionTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "poster1")
        imageView.layer.cornerRadius = 15
        imageView.layer.borderWidth = 6
        imageView.clipsToBounds = true
        imageView.layer.borderColor = Colors.ypRed.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private func setupViews() {
        
        view.backgroundColor = Colors.ypBackground
        
        view.addSubview(questionTextLabel)
        view.addSubview(scoreLabel)
        view.addSubview(yesButton)
        view.addSubview(noButton)
        view.addSubview(questionLabel)
        view.addSubview(posterImageView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            questionTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            yesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            yesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            yesButton.widthAnchor.constraint(equalToConstant: 158),
            yesButton.heightAnchor.constraint(equalToConstant: 60)

        ])
        NSLayoutConstraint.activate([
            noButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            noButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            noButton.widthAnchor.constraint(equalToConstant: 158),
            noButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            questionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -91),
            questionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -62),
            questionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 62),
        ])
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: questionTextLabel.bottomAnchor, constant: 20),
            posterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -178),
            posterImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            posterImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 335),
            //posterImageView.heightAnchor.constraint(equalToConstant: 502)

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
