import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBAction func showAlert(_ sender: UIButton) {
        /*let callback = {
            print("Hello")
        }
        let alert = ResultAlertPresenter(title: "TITLE", message: "MESSAGE", controller: self, completion: @escaping () -> Void)
        alert.show()*/
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let tmpcurrentQuestion = currentQuestion else {
            return
        }
        print("CQ: "+currentQuestion!.image)
        if !currentQuestion!.correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let tmpcurrentQuestion = currentQuestion else {
            return
        }
        print("CQ: "+currentQuestion!.image)
        if currentQuestion!.correctAnswer {
            showAnswerResult(isCorrect: true)
        }
        else {
            showAnswerResult(isCorrect: false)
        }
    }

    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel: QuizeStepViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: "")
    private var resultsViewModel: QuizeResultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy: Double = 0.0
    private var buttonsBlocked: Bool = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(image: model.image, question: model.text, questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)")
    }

    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        currentViewModel = step
        moviePoster.image = UIImage(named: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func show(quize result: QuizeResultsViewModel) {
        let someClosure: (QuizeQuestion) -> () = { question in
            self.show(quize: self.convert(model: question))
        }
        let alert = ResultAlertPresenter(title: result.title, message: result.text, controller: self/*, someClosure: someClosure(currentQuestion!)*/)
        alert.show()
        /*guard let tmpQuestion = self.currentQuestion else {
            return
        }
        self.show(quize: self.convert(model: tmpQuestion))*/
    }

    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moviePoster.layer.borderWidth = 8
        if isCorrect {
            moviePoster.layer.borderColor = greenColor
            corrects += 1
        }
        else {
            moviePoster.layer.borderColor = redColor
            wrongs += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        questionNumberGlobal += 1
        guard questionNumberGlobal < questionsAmount else {
            rounds += 1
            if corrects > records {
                records = corrects
                let temporaryDateVar = Date()
                recordDate = temporaryDateVar.dateTimeString
            }
            if corrects > 0 {
                accuracy.append((Double(corrects) / Double(questionsAmount)) * 100.0)
            }
            else {
                accuracy.append(0.0)
            }
            if !accuracy.isEmpty {
                sumAccuracy = 0.0
                for element in accuracy {
                    sumAccuracy += element
                }
                print(sumAccuracy)
                avgAccuracy = sumAccuracy / Double(accuracy.count)
            }
            if corrects != questionsAmount {
                resultsViewModel.title = "Этот раунд окончен!"
            }
            else {
                resultsViewModel.title = "Потрясающе!"
            }
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\nКоличество сыграных квизов:\(rounds)\nРекорд: \(records)/\(questionsAmount) (\(recordDate))"
            resultsViewModel.text += "\nСредняя точность: \(avgAccuracy)%"
            corrects = 0
            wrongs = 0
            questionNumberGlobal = 0
            show(quize: resultsViewModel)
            return
        }
        questionFactory?.requestNextQuestion()
    }
    
    enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    func string(from fileURL: URL) throws -> String {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            throw FileManagerError.fileDoesntExist
        }
        var str = ""
        do {
            str = try String(contentsOf: fileURL)
        } catch FileManagerError.fileDoesntExist {
            print ("File on URL \(fileURL.path) doesn't exist")
        } catch {
            print("Unknown error")
        }
        return str
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        // MARK: Filesystem
        /*
        print(NSHomeDirectory())
        //UserDefaults.standard.set(true, forKey: "viewDidLoad")
        //print(Bundle.main.bundlePath)
        var documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //print(documentsUrl.scheme)
        //print(documentsUrl.path)
        let fileName = "text.swift"
        let hello = "Hello World!"
        let data = hello.data(using: .utf8)
        documentsUrl.appendPathComponent(fileName)
        FileManager.default.createFile(atPath: documentsUrl.path, contents: data)
        try? print(String(contentsOf: documentsUrl))
        //print(documentsUrl.path)
        //-------------------
         */
        
        //MARK: json
        //let jsonString1: String
        var documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let fileService: FileService
        documentsUrl.appendPathComponent("inception.json")
        guard let jsonString = try? string(from: documentsUrl) else {
            return
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        //print(json)
        //print(json["title"])
        guard let actorList = json["actorList"] as? [Any] else {
            return
        }
        for actor in actorList {
            guard let actor = actor as? [String: Any] else {
                return
            }
            print(actor["asCharacter"])
        }
        //----------
        //MARK: JSON homework
        struct Actor {
            let id: String
            let image: String
            let name: String
            let asCharacter: String
        }
        struct Movie {
            let id: String
            let title: String
            let year: Int
            let image: String
            let releaseDate: String
            let runtimeMins: Int
            let directors: String
            let actorList: [Actor]
        }
        var actorList1: [Actor] = []
        for actor1 in actorList {
            guard let tmpActor = actor1 as? [String: Any] else {
                return
            }
            let tmpActor1: Actor = Actor(id: tmpActor["id"] as! String, image: tmpActor["image"] as! String, name: tmpActor["name"] as! String, asCharacter: tmpActor["asCharacter"] as! String)
            actorList1.append(tmpActor1)
        }
        
        let theMovie: Movie = Movie(
            id: json["id"] as! String,
            title: json["title"] as! String,
            year: Int(json["year"] as! String)!,
            image: json["image"] as! String,
            releaseDate: json["releaseDate"] as! String,
            runtimeMins: Int(json["runtimeMins"] as! String)!,
            directors: json["directors"] as! String,
            actorList: actorList1)
        print("Movie:")
        print(theMovie)
        //-------------------
        
    }
    
    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizeQuestion?) {
        guard
            let question = question
        else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quize: viewModel)
        }
    }
}
