import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak var changeDayConditionButton: UIButton!
    @IBOutlet weak var dayConditionImageView: UIImageView!
    // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
        }
        
        func setupView() {
            // MARK: Setup Image.
            dayConditionImageView.image = UIImage(systemName: "moon")
            dayConditionImageView.contentMode = .scaleAspectFill
            dayConditionImageView.tintColor = .black
            
            
            // MARK: Setup button.
            changeDayConditionButton.layer.cornerRadius = 7
            
            changeDayConditionButton.setTitle("Change color of a sun!", for: .normal)
            
            changeDayConditionButton.backgroundColor = .black
            changeDayConditionButton.tintColor = .white
            
            
            changeDayConditionButton.addTarget(self, action: #selector(changeImageColorHandler), for: .touchUpInside)
            
            
            dayConditionImageView.translatesAutoresizingMaskIntoConstraints = false
            
            changeDayConditionButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dayConditionImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                dayConditionImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
                dayConditionImageView.heightAnchor.constraint(equalToConstant: 400),
                dayConditionImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dayConditionImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                changeDayConditionButton.topAnchor.constraint(equalTo: dayConditionImageView.bottomAnchor, constant: 150),
                changeDayConditionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
                
        }
        
        @objc func changeImageColorHandler() {
            
            if (dayConditionImageView.tintColor == .yellow) {
                dayConditionImageView.image = UIImage(systemName: "moon")
                dayConditionImageView.tintColor = .black
                changeDayConditionButton.backgroundColor = .black
            } else {
                dayConditionImageView.tintColor = .yellow
                dayConditionImageView.image = UIImage(systemName: "sun.max")
                changeDayConditionButton.backgroundColor = .blue
            }
            
            
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
