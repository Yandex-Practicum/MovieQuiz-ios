//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 19.08.2023.
//

import UIKit

protocol MovieQuizPresenterProtocol {
    func didAnswer(isYes: Bool)
}

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticService = StatisticServiceImplementation()
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        showLoadingIndicator(is: true)
        questionFactory?.loadData()
    }
    
    // MARK: - Private methods
    
    /// Выясняем, является ли текущий вопрос последним в квизе
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    /// Инкрементируем порядковый номер текущего вопроса
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    /// Реагируем на ответ пользователя (нажатие кнопки ответа) - окрашиваем рамку картинки, переходим к следующему вопросу
    /// - Parameters:
    ///     - isCorrect: индикатор верности ответа
    private func showAnswerResult(isCorrect: Bool){
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
        
        // Запрашиваем следующий вопрос с deadline-задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    /// Отображение следующего вопроса или результатов
    private func proceedToNextQuestionOrResults(){
       
        // Если предыдущий вопрос был последним подводим итог текущей игры
        if isLastQuestion() {
            
            let totalQuestions = currentQuestionIndex + 1
            statisticService.store(correct: correctAnswers, total: totalQuestions)
            
            // Подготавливаем уведомление
            let bestGame = statisticService.bestGame
            let text = """
                Ваш результат: \(correctAnswers)/\(totalQuestions)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.accuracy))%
            """
            let alertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: startNewQuiz)
            
            // Отображаем уведомление
            viewController?.show(alert: alertModel)
            
        // Иначе переходим к следующему вопросу
        } else {
            // Инкриментируем счётчик текущего вопроса
            switchToNextQuestion()
            // Посылаем запрос на вопрос на фабрику вопросов
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Methods
    
    /// Метод вызываемый по нажатию кнопок Да/Нет
    func didAnswer(isYes: Bool) {
        viewController?.toggleButtons(to: false)
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == isYes)
    }
    
    /// Подготовка вопроса к визуализации
    /// - Parameters:
    ///     - question: QuizQuestion-структура
    /// - Returns: Возвращает структуру "QuizStepViewModel" для отображения вопроса в представлении
    func convert(question: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    /// Функция для инициализации квиз-раунда
    func startNewQuiz( _ : UIAlertAction){
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
}

// MARK: - QuestionFactoryDelegate
/// Расширение для соответствия делегату фабрики вопросов
extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    /// Получили данные с сервера, запускаем квиз
     func didLoadDataFromServer() {
        viewController?.showLoadingIndicator(is: false)
        questionFactory?.requestNextQuestion()
    }
    
    /// Отображаем уведомление о возникновении ошибки на уровне сети
    func didFailToLoadData(alert model: AlertModel) {
        showLoadingIndicator(is: false)
        viewController?.show(alert: model)
    }
    
    /// Запускаем/отключаем индикатор активности по мере необходимости
    func showLoadingIndicator(is state: Bool) {
        viewController?.showLoadingIndicator(is: state)
    }
    
    /// Подготовка модели и отображение нового вопроса
    func didReceiveNextQuestion(question: QuizQuestion?){
       
        guard let question  = question else { return }
        
        currentQuestion = question
        
        let viewModel = convert(question: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quizStep: viewModel)
        }
    }
}
