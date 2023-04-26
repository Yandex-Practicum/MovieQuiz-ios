import Foundation
/* Задание:
 Предлагаем вам в эту структуру самостоятельно добавить метод сравнения рекордов, исходя из количества правильных ответов.

 Подсказка
 Вы можете это сделать, изучив протокол Comparable, а можете добавить в структуру метод, принимающий другую структуру типа GameRecord и производящий нужное сравнение.
 Обратите внимание: она подписана на протокол Codable, чтобы её можно было сохранить в UserDefaults.


 */


struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date

    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
    return lhs.correct < rhs.correct
    }
}



