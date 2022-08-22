import UIKit

struct QuizScores {
    var gamesPlayed: Int = 1 // сколько было сыграно игр
    var score: Int = 0 // сколько набрано очков
    var record: Int = 0 // каков рекорд
    var recordTime: String = "" // время, когда набран рекорд
    var accuracyCurrent: Float = 0 // Точность пройденного квиза
    var accuracyAll: Float = 0 // Суммарная точность всех квизов, который были пройдены раньше

    var currentTime: String { // текущее время
        let date = Date()
        return date.dateTimeString
    }


    mutating func accuracyAverage() -> String { // Вычисление средней точности всех квизов
        accuracyCurrent = Float(100 / 10 * score)
        accuracyAll += accuracyCurrent
        return String(format: "%.2f", accuracyAll / Float(gamesPlayed))
    }

    mutating func itIsRecord() { // проверка на рекорд
        if score >= record {
            record = score // присваиваем текущий результат квиза как рекорд
            recordTime = currentTime // присваиваем текущее время как время рекорда
        }
    }

    mutating func restartQuiz() { // Записываем +1 в количество сыгранных игр
        gamesPlayed += 1
        score = 0
    }
}
