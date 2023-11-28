import UIKit



final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Lifecycle
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textLabel: UILabel!
    
    @IBOutlet var counterLabel: UILabel!
    
    @IBOutlet var noButtonClicked: UIButton!
    
    @IBOutlet var yesButtonClicked: UIButton!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = true
        
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer ==  currentQuestion.correctAnswer)
    }
    
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    

    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionsAmount = 10
    
    private var currentQuestion: QuizQuestion?
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticPresenter: StatisticServiceImplementation = StatisticServiceImplementation()
    
    private func resetImageBorederColor() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    
    private func convert (model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect == true {
            correctAnswers += 1
        }
        
        noButtonClicked.isEnabled = false
        yesButtonClicked.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showAlertPresenter() {
        statisticPresenter.store(correct: correctAnswers, total: questionsAmount)
        
        guard let bestGame = statisticPresenter.gameRecord else {return}

        
        let TotalGamesString = "количество сыгранных квизов: \(statisticPresenter.gamesCount)"
        let bestGameString = "рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let accuracyOfAnswers = "Средяя точность: \(String(format: "%.2f", statisticPresenter.totalAccuracy))%"
        
        let text = "Ваш результат \(correctAnswers)/\(questionsAmount)"
        
        let someVar = AlertModel(title: "Этот раунд окончен!", message: "\(text)\n\(TotalGamesString)\n\(bestGameString)\n\(accuracyOfAnswers)", buttonText: "Сыграть ещё раз", comletion: { [weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        })
        
        
        alertPresenter.controller = self
        alertPresenter.show2(quiz: someVar)
        resetImageBorederColor()
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {

            showAlertPresenter()
            
        } else {
            
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
        
        noButtonClicked.isEnabled = true
        yesButtonClicked.isEnabled = true
    }
    
    
    private func string(from documentsURL: URL) throws -> String {
        
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            
            throw FileManagerError.fileDoesntExist
        }
        
        return try String(contentsOf: documentsURL)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let documentsURl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        
//        let newFile2 = documentsURl.appendingPathComponent("top250MoviesIMDB.json")
//        
//        let top250Movies = try? string(from: newFile2)
//        guard let top250Movies = top250Movies else {return}
//        
//        
//        let data2 = top250Movies.data(using: .utf8)
//        guard let data2 = data2 else {return}
        
//        do {
//            let top250Movies1 = try JSONDecoder().decode(JsonFileDecoder.Top.self, from: data2)
//            print(top250Movies1)
//        } catch {
//            print("error")
//        }
        
//        statisticPresenter = StatisticServiceImplementation()
        questionFactory.delegate = self
        
        resetImageBorederColor()
        questionFactory.requestNextQuestion()
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        resetImageBorederColor()
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}









//        print(documentsURl)
//        let newFile = documentsURl.appendingPathComponent("inception.json")
//
//        let jsonString = try? string(from: newFile)
//        guard let jsonString = jsonString else {return}
//
//
//        var data = jsonString.data(using: .utf8)
//        guard let data = data else {return}
//        do {
//            let movie = try JSONDecoder().decode(Movie.self, from: data )
//            print(movie)
//        } catch { print("")}



// MARK: - Movie: getMovie(from jsonString: String)

//    func getMovie(from jsonString: String) -> Movie? {
//        var movie: Movie? = nil
//        do {
//            guard let data = jsonString.data(using: .utf8) else {
//                return nil
//            }
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//            guard let json = json,
//                  let id = json["id"] as? String,
//                  let title = json["title"] as? String,
//                  let jsonYear = json["year"] as? String,
//                  let year = Int(jsonYear),
//                  let image = json["image"] as? String,
//                  let releaseDate = json["releaseDate"] as? String,
//                  let jsonRuntimeMins = json["runtimeMins"] as? String,
//                  let runtimeMins = Int(jsonRuntimeMins),
//                  let directors = json["directors"] as? String,
//                  let actorList = json["actorList"] as? [Any] else {
//                return nil
//            }
//
//            var actors: [Actor] = []
//
//            for actor in actorList {
//                guard let actor = actor as? [String: Any],
//                      let id = actor["id"] as? String,
//                      let image = actor["image"] as? String,
//                      let name = actor["name"] as? String,
//                      let asCharacter = actor["asCharacter"] as? String else {
//                    return nil
//                }
//                let mainActor = Actor(id: id,
//                                      image: image,
//                                      name: name,
//                                      asCharacter: asCharacter)
//                actors.append(mainActor)
//            }
//            movie = Movie(id: id,
//                          title: title,
//                          year: year,
//                          image: image,
//                          releaseDate: releaseDate,
//                          runtimeMins: runtimeMins,
//                          directors: directors,
//                          actorList: actors)
//        } catch {
//            print("Failed to parse: \(jsonString)")
//        }
//
//        return movie
//    }


// MARK: - Movie: Decodable

//    enum ParseError: Error {
//        case yearFailure
//        case runtimeMinsFailure
//    }
//
//    struct Actor: Decodable {
//        let id: String
//        let image: String
//        let name: String
//        let asCharacter: String
//    }
//
//    struct Movie: Decodable {
//        let id: String
//        let title: String
//        let year: Int
//        let image: String
//        let releaseDate: String
//        let runtimeMins: Int
//        let directors: String
//        let actorList: [Actor]
//
//
//        enum CodingKeys: CodingKey {
//            case id, title, year, image, releaseDate, runtimeMins, directors, actorList
//        }
//
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            id = try container.decode(String.self, forKey: .id)
//            title = try container.decode(String.self, forKey: .title)
//
//            let year = try container.decode(String.self, forKey: .year)
//            guard let yearValue = Int(year) else {
//                throw ParseError.yearFailure
//            }
//            self.year = yearValue
//
//            image = try container.decode(String.self, forKey: .image)
//            releaseDate = try container.decode(String.self, forKey: .releaseDate)
//
//            let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
//            guard let runtimeMinsValue = Int(runtimeMins) else {
//                throw ParseError.runtimeMinsFailure
//            }
//            self.runtimeMins = runtimeMinsValue
//
//            directors = try container.decode(String.self, forKey: .directors)
//            actorList = try container.decode([Actor].self, forKey: .actorList)
//        }
//    }




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
