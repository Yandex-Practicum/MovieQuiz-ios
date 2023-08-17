//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Ivan on 12.07.2023.
//
import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.cornerRadius = 20
        showLoadingIndicator()
        statisticService = StatisticServiceImplementation()
    }
    
    // MARK: - Private functions
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
            self.presenter?.correctAnswers = 0
            
        }
        alertPresenter?.showQuizResult(for: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func enabledButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
}


