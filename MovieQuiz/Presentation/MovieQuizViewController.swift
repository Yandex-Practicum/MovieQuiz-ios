import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var QuestionTitleLabel: UILabel!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var IndexLabel: UILabel!
    @IBOutlet weak var PreviewImage: UIImageView!
    @IBOutlet weak var YesButton: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ypBlack
        
        NoButton.setTitle("Нет", for: .normal)
        NoButton.setTitleColor(UIColor.ypBlack, for: .normal)
        NoButton.backgroundColor = UIColor.ypWhite
        NoButton.layer.cornerRadius = 15
        NoButton.frame.size = CGSize(width: 157, height: 60)
        
        YesButton.setTitle("Да", for: .normal)
        YesButton.setTitleColor(UIColor.ypBlack, for: .normal)
        YesButton.backgroundColor = UIColor.ypWhite
        YesButton.layer.cornerRadius = 15
        YesButton.frame.size = CGSize(width: 157, height: 60)
        
        QuestionTitleLabel.text = "Вопрос:"
        QuestionTitleLabel.textColor = UIColor.ypWhite
        QuestionTitleLabel.frame.size = CGSize(width: 72, height: 24)
        QuestionTitleLabel.font = UIFont(name: "YS Display", size: 20)
        
        IndexLabel.text = "1/10"
        IndexLabel.textColor = UIColor.ypWhite
        IndexLabel.frame.size = CGSize(width: 72, height: 24)
        IndexLabel.font = UIFont(name: "YS Display", size: 20)
        QuestionLabel.textColor = UIColor.ypWhite
        QuestionLabel.frame.size = CGSize(width: 72, height: 24)
        QuestionLabel.font = UIFont(name: "YS Display", size: 23)
        QuestionLabel.text = "Рейтинг этого фильма меньше 5?"
    }
}
struct QuizQuestion {
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}


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
