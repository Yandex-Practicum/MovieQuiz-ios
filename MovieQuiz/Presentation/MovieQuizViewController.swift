import UIKit

enum FontDefault {
    static let bold = "YSDisplay-Bold"
    static let medium = "YSDisplay-Medium"
    static let size = 20.0
}

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerCounterLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!

    var allQuestions: Int = 10
    var currentPosition: Int = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    // MARK: - Private methods

    /// Default configuration storyboard elements
    private func configuration() {
        viewContainer.backgroundColor = UIColor.appBackground

        headerTitleLabel.font = UIFont(name: FontDefault.medium, size: FontDefault.size)
        headerCounterLabel.font = UIFont(name: FontDefault.medium, size: FontDefault.size)

        questionTextLabel.text = "..."
        questionTextLabel.font = UIFont(name: FontDefault.bold, size: 23.0)

        imageQuestionStyle(image: questionImageView)

        // TODO: на сколько я понимаю, должен быть вариант создания дизайн-системы с наследованием класса UIButton
        buttonStyle(button: falseButton)
        buttonStyle(button: trueButton)
    }

    /// Default buttons style
    private func buttonStyle(button: UIButton) {
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.appDefault
        button.tintColor = UIColor.appBackground

        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont(name: FontDefault.bold, size: FontDefault.size)
        button.titleEdgeInsets = UIEdgeInsets(top: 18.0, left: 16.0, bottom: 18.0, right: 16.0)
    }

    private func imageQuestionStyle(image: UIImageView) {
        image.layer.borderWidth = 8
        image.layer.cornerRadius = 20

        imageResetStyle(image: image)
    }

    private func imageResetStyle(image: UIImageView) {
        image.layer.borderColor = .none
    }

    private func answerSuccess(image: UIImageView) {
        image.layer.borderColor = UIColor.appSuccess.cgColor
    }

    private func answerFail(image: UIImageView) {
        image.layer.borderColor = UIColor.appFail.cgColor
    }
}
