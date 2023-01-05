import Foundation
     // протокол для связи c MQVC
 protocol StatisticService {
     var totalAccuracy: Double { get }
     var gamesCount: Int { get }
     var bestGame: GameRecord { get }
     func store(correct count: Int, total amount: Int)
 }
// Структура лучшей игры
struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    //метод сравнения пройденного раунда с лучшим
    func compare (count: GameRecord) -> Bool {
        count.correct > self.correct
    }
}
 // создаем класс для хранения данных о результатах игр, подписываем на протокол
 final class StatisticServiceImplementation: StatisticService {

     private enum Keys: String { // ключи для работы с userDefaults
         case correct, total, bestGame, gamesCount
     }

     private let userDefaults = UserDefaults.standard //переменная для работы с userDefaults

     private(set) var correct: Int {
         get { // устанавливаем переменную, отвечающую за общее кол-во правильных ответов
             let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
             return correctAnswers
         }
         set { // сохраняем новое значение correct в userDefaults
             userDefaults.set(newValue, forKey: Keys.correct.rawValue)
         }
     }
     private(set) var total: Int { // переменная хранящая общее кол-во заданных вопросов
         get { //считываем в userDefaults значение общего количества вопросов
             let totalCorrectAnswers = userDefaults.integer(forKey: Keys.total.rawValue)
             return totalCorrectAnswers
             
         }
         set { // сеттер общего кол-ва заданных вопросов
             userDefaults.set(newValue, forKey: Keys.total.rawValue)
         }
     }
     private(set) var gamesCount: Int { // переменная кол-ва всех сыгранных игр
         get { //геттер кол-ва сыгранных игр
               let gamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
               return gamesCount
           }
         set { //сеттер кол-ва сыгранных игр
             userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
         }

       }
     var totalAccuracy: Double { // переменная средней точности ответа
         get { // вычисляемая переменная, формула: (кол-во правильных ответов / кол-во всех ответов)*100, в процентах
             return (Double(self.correct)/Double(self.total)) * 100
         }

     }

     private(set) var bestGame: GameRecord { // переменная лучшей игры
         get {
             guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                   let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                 return .init(correct: 0, total: 0, date: Date())
             }
             return record
         }
         set { // с помощью JSONEncoder преобразуем структуру GameRecord которая хранится в переменной newValue в тип Data переменной data
             guard let data = try? JSONEncoder().encode(newValue) else {
             print("Невозможно сохранить результат!")
                 return

         } // сохраняем переменную data в userDefaults
             userDefaults.set(data, forKey: Keys.bestGame.rawValue)

         }

     }
     // создаем функцию, которая позволит хранить результаты каждого пройденного раунда
     func store(correct count: Int, total amount: Int) {
         self.correct += count
         self.total += amount
         self.gamesCount += 1
         let counter = GameRecord(correct: count, total: amount, date: Date())
         if bestGame.compare(count:counter) { //в случае лучшего результата сохраняем в bestGame
             bestGame = counter
         }
     }
 }
