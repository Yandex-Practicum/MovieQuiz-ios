import UIKit

final class MovieQuizViewControllerTest: UIViewController {
    
    // MARK: - Type alias
    private typealias Title = Constants.Title
    
    // MARK: - Private Properties
    //Метод 1
    private var yesButton: CustomButton?
    private var noButton: CustomButton?
    private var questionTitleLabel: CustomLabel?
    private var indexLabel: CustomLabel?
    private var questionLabel: UILabel?
    private var stackViewButtons: UIStackView?
    private var stackViewLabels: UIStackView?
    private var previewImage: UIImageView?
    
    //Метод 2
    //        private let testButton: CustomButton = {
    //            var testButton = CustomButton()
    //            testButton.setTitle("testButton", for: .normal)
    //                ...
    //            return testButton
    //        }()
    
    /*
     Подскажите пожалуйста, какой метод создания UI элемента используется в яндексе 1 или 2?
     */
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypBackground
        setupUI()
        setupConstraints()
    }
    
    @objc private func test1() {
        print("tap yes button")
    }
    
    @objc private func test2() {
        print("tap no button")
    }
}

extension MovieQuizViewController {
    
    // MARK: - Private Methods in extension
    //MARK: setup UI
    private func setupUI() {
        setupStackView()
        setupButtons()
        setupLabels()
        setupImage()
    }
    
    private func setupButtons() {
        guard let stackView = stackViewButtons else { return }
        setupYesButton(stackView: stackView)
        setupNoButton(stackView: stackView)
    }
    
    private func setupLabels() {
        guard let stackView = stackViewLabels else { return }
        setupQuestionLabel(stackView: stackView)
        setupIndexLabel(stackView: stackView)
        setupQuestionLabel()
    }
    
    private func setupStackView() {
        setupStackViewButtons()
        setupStackViewLabels()
    }
    
    private func setupImage() {
        setupPreviewImage()
    }
    
    //MARK: setup stack
    private func setupStackViewButtons() {
        let stackViewButtons = UIStackView()
        stackViewButtons.axis = .horizontal
        stackViewButtons.alignment = .fill
        stackViewButtons.distribution = .fillEqually
        stackViewButtons.spacing = 20
        view.addSubview(stackViewButtons)
        self.stackViewButtons = stackViewButtons
    }
    
    private func setupStackViewLabels() {
        let stackViewLabels = UIStackView()
        stackViewLabels.axis = .horizontal
        view.addSubview(stackViewLabels)
        self.stackViewLabels = stackViewLabels
    }
    
    //MARK: setup UI Button
    private func setupYesButton(stackView: UIStackView) {
        let yesButton = CustomButton()
        yesButton.setTitle(Title.yes.rawValue, for: .normal)
        yesButton.addTarget(self, action: #selector(test1), for: .touchUpInside)
        self.view.addSubview(yesButton)
        self.yesButton = yesButton
    }
    
    private func setupNoButton(stackView: UIStackView) {
        let noButton = CustomButton()
        noButton.setTitle(Title.no.rawValue, for: .normal)
        noButton.addTarget(self, action: #selector(test2), for: .touchUpInside)
        self.view.addSubview(noButton)
        self.noButton = noButton
    }
    
    //MARK: setup UI Label
    private func setupQuestionLabel(stackView: UIStackView) {
        let questionLabel = CustomLabel()
        questionLabel.text = Title.question.rawValue
        stackView.addSubview(questionLabel)
        self.questionTitleLabel = questionLabel
    }
    
    private func setupIndexLabel(stackView: UIStackView) {
        let indexLabel = CustomLabel()
        indexLabel.text = "1/10"
        stackView.addSubview(indexLabel)
        self.indexLabel = indexLabel
    }
    
    private func setupQuestionLabel() {
        let questionLabel = UILabel()
        questionLabel.text = "Рейтинг этого фильма меньше чем 5?"
        questionLabel.textColor = .ypWhite
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        self.view.addSubview(questionLabel)
        self.questionLabel = questionLabel
    }
    
    //MARK: setup UI Image
    private func setupPreviewImage() {
        let previewImage = UIImageView()
        previewImage.backgroundColor = .ypWhite
        self.view.addSubview(previewImage)
        self.previewImage = previewImage
    }
    
    //MARK: setup constraints
    private func setupConstraints() {
        setupButtonsConstraints()
        setupLabelConstraints()
        setupStackViewConstraints()
        setupImageConstraints()
    }
    
    private func setupStackViewConstraints() {
        setupStackViewButtonsConstraints()
        setupStackViewLabelsConstraints()
    }
    
    private func setupButtonsConstraints() {
        guard let stackViewButtons = stackViewButtons else { return }
        setupNoButtonConstraints(stackView: stackViewButtons)
        setupYesButtonConstraints(stackView: stackViewButtons)
    }
    
    private func setupLabelConstraints() {
        guard let stackViewLabels = stackViewLabels else { return }
        setupQuestionLabelConstraints(stackView: stackViewLabels)
        setupIndexLabelConstraints(stackView: stackViewLabels)
        setupQuestionLabelConstraints()
    }
    
    private func setupImageConstraints() {
        setupPreviewImageConstraints()
    }
    
    //MARK: setup Button constraints
    private func setupNoButtonConstraints(stackView: UIStackView) {
        guard let noButton = noButton else { return }
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        noButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        noButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupYesButtonConstraints(stackView: UIStackView) {
        guard let yesButton = yesButton else { return }
        guard let noButton = noButton else { return }
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        yesButton.leadingAnchor.constraint(equalTo: noButton.trailingAnchor, constant: 20).isActive = true
        yesButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        yesButton.heightAnchor.constraint(equalTo: noButton.heightAnchor).isActive = true
        yesButton.widthAnchor.constraint(equalTo: noButton.widthAnchor).isActive = true
    }
    
    //MARK: setup Label constraints
    private func setupQuestionLabelConstraints(stackView: UIStackView) {
        guard let questionLabel = questionTitleLabel else { return }
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }
    
    private func setupIndexLabelConstraints(stackView: UIStackView) {
        guard let indexLabel = indexLabel else { return }
        guard let questionTitleLabel = questionTitleLabel else { return }
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        indexLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0).isActive = true
        indexLabel.leadingAnchor.constraint(greaterThanOrEqualTo: questionTitleLabel.trailingAnchor, constant: 20).isActive = true
        
    }
    
    private func setupQuestionLabelConstraints() {
        guard let questionLabel = questionLabel else { return }
        guard let stackViewButtons = stackViewButtons else { return }
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: stackViewButtons.topAnchor, constant: -20).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    }
    
    //MARK: setup Images constraints
    private func setupPreviewImageConstraints() {
        guard let previewImage = previewImage else { return }
        guard let questionLabel = questionLabel else { return }
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        previewImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        //TODO: 2/3 не получается(вылазит за пределы экрана), просьба помочь
        previewImage.widthAnchor.constraint(lessThanOrEqualTo: previewImage.heightAnchor, multiplier: 2/3).isActive = true
        previewImage.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -20).isActive = true
    }
    
    //MARK: setup stack view constraints
    private func setupStackViewButtonsConstraints() {
        guard let stackViewButtons = stackViewButtons else { return }
        stackViewButtons.translatesAutoresizingMaskIntoConstraints = false
        stackViewButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackViewButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackViewButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        stackViewButtons.heightAnchor.constraint(equalToConstant: 60).isActive = true
        stackViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupStackViewLabelsConstraints() {
        guard let stackViewLabels = stackViewLabels else { return }
        stackViewLabels.translatesAutoresizingMaskIntoConstraints = false
        stackViewLabels.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackViewLabels.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stackViewLabels.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        stackViewLabels.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
