import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var LabelQuestion: UILabel!
    @IBOutlet weak var NoButton: UIButton!
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
        
        LabelQuestion.text = "Вопрос:"
        LabelQuestion.textColor = UIColor.ypWhite
        LabelQuestion.frame.size = CGSize(width: 72, height: 24)
        LabelQuestion.font = UIFont(name: "YS Display", size: 20)
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
