import UIKit

class AlertPresenter: AlertPresenterProtocol {
//    func show(quiz result: QuizResultViewModel?) {
//        <#code#>
//    }
    

    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: model.buttonText,
                                   style: .default,
                                   handler: { [ weak self ] _ in
            guard self != nil else { return } // optional weak link is commonly deployed
//            self.questionFactory?.requestNextQuestion()
//            self.correctAnswers = 0
            //let newGame = self.questions[self.currentQuestionIndex]
            //self.show(quiz: self.convert(model: newGame))
        })
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
        // self.present(alert, animated: true, completion: nil)
    }
}
