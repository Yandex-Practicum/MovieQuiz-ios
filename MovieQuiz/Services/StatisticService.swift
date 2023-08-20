//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 03.08.2023.
//
//Сущность для взаимодействия с UserDefaults
import Foundation
// Протокол определяет интерфейс для взаимодействия с UserDefaults и хранения статистики игр
protocol StatisticService {
    // Метод для сохранения текущего результата игры. Принимает количество правильных ответов и общее количество вопросов в игре.
    func store(correct count: Int, total amount: Int)
    // Свойство, хранящее общую точность (accuracy) всех сыгранных игр.
    var totalAccuracy: Double { get }
    // Свойство, хранящее общее количество сыгранных игр.
    var gamesCount: Int { get }
    // Свойство, хранящее информацию о лучшей сыгранной игре.
    var bestGame: GameRecord { get }
    // Свойство, хранящее количество правильных ответов за все сыгранные игры.
    var totalCorrectAnswers: Int { get }
    // Свойство, хранящее общее количество вопросов за все сыгранные игры.
    var totalQuestionsPlayed: Int { get }
}
// Класс, реализующий протокол StatisticService для работы с UserDefaults и хранения статистики игр.
final class StatisticServiceImplementation: StatisticService {
    // Переменные для хранения данных о статистике игр
    var totalAccuracy: Double {
        guard totalQuestionsPlayed > 0 else {
            return 0.0
        }
        return Double(totalCorrectAnswers) / Double(totalQuestionsPlayed) * 100
    }
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            // При установке свойства, сохраняем новое значение в UserDefaults
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    // Свойство, хранящее информацию о лучшей сыгранной игре. Загружается из UserDefaults при доступе к свойству.
    var bestGame: GameRecord {
        get {
            // Пытаемся получить данные о лучшей игре из UserDefaults
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                // Если данных нет или не удалось декодировать, возвращаем пустую запись
                return .init(correct: 0, total: 0, date: Date())
            }
            // Возвращаем информацию о лучшей игре
            return record
        }
        set {
            // При установке свойства, кодируем новую игру в JSON и сохраняем в UserDefaults
            guard let data = try? JSONEncoder().encode(newValue) else {
                // Если не удалось закодировать, выводим сообщение об ошибке
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    private let userDefaults = UserDefaults.standard
    // Перечисление для хранения ключей UserDefaults
    private enum Keys: String {
        case totalCorrectAnswers, totalQuestionsPlayed, bestGame, gamesCount, totalAccuracy
    }
    init() {
        // Инициализируем свойства значениями из UserDefaults, если они доступны, иначе устанавливаем значения по умолчанию.
        gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        totalCorrectAnswers = userDefaults.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        totalQuestionsPlayed = userDefaults.integer(forKey: Keys.totalQuestionsPlayed.rawValue)
    }
    // Приватные свойства для хранения информации о результатах игр
    internal var totalCorrectAnswers: Int = 0
    internal var totalQuestionsPlayed: Int = 0
    // Метод для сохранения текущего результата игры
    func store(correct count: Int, total amount: Int) {
        // Обновляем значения totalCorrectAnswers и totalQuestionsPlayed на основе переданных данных
        totalCorrectAnswers += count
        totalQuestionsPlayed += amount
        // Обновляем значение gamesCount при каждом вызове метода
        gamesCount += 1
        // Проверяем, является ли новая игра лучшей, и обновляем bestGame при необходимости
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        if newGameRecord.isBetter(than: bestGame) {
            bestGame = newGameRecord
        }
        // После обновления свойств, также сохраняем их в UserDefaults
        userDefaults.set(totalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        userDefaults.set(totalQuestionsPlayed, forKey: Keys.totalQuestionsPlayed.rawValue)
    }
}
// Структура для хранения записи об игре
struct GameRecord: Codable {
    let correct: Int // Количество правильных ответов
    let total: Int // Общее количество вопросов
    let date: Date // Дата игры
    // Метод для сравнения рекордов на основе количества правильных ответов
    func isBetter(than otherRecord: GameRecord) -> Bool {
        // Сравниваем по количеству правильных ответов в игре
        return correct > otherRecord.correct
    }
    // Свойство для получения текста с рекордом, формируемого для вывода в алерт
    var recordText: String {
        let dateString = date.dateTimeString
        return "Дата: \(dateString)\nПравильных ответов: \(correct) из \(total)\nТочность: \(String(format: "%.2f", Double(correct) / Double(total) * 100))%"
    }
    // Метод для расчета средней точности
    static func averageAccuracy(totalCorrect: Int, totalQuestions: Int) -> Double {
        guard totalQuestions > 0 else {
            return 0.0
        }
        return Double(totalCorrect) / Double(totalQuestions) * 100
    }
}
