
import Foundation

final class StatisticServiceImplementation: StatisticService {
  private let userDefaults = UserDefaults.standard
  
  var totalAccuracy: Double {
    get {
      let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
      let totalQuestions = userDefaults.integer(forKey: Keys.total.rawValue)
      if correctAnswers == 0 || totalQuestions == 0 {
        return 0
      }
      return Double(correctAnswers) / Double(totalQuestions) * 100
    }

  }
  
  private(set) var gamesCount: Int {
    get {
      userDefaults.integer(forKey: Keys.gamesCount.rawValue)
    }
    
    set {
      userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
    }
  }
  
  private(set) var bestGame: GameRecord {
    get {
      guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue), let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
        return .init(correct: 0, total: 0, date: Date())
      }
      return record
    }
    set {
      guard let data = try? JSONEncoder().encode(newValue) else {
        print("Невозможно сохранить результат")
        return
      }
      userDefaults.set(data, forKey: Keys.bestGame.rawValue)
    }
  }
  
  func store(correct count: Int, total amount: Int) {
    gamesCount += 1
    
    let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
    let totalQuestions = userDefaults.integer(forKey: Keys.total.rawValue)
    userDefaults.set(correctAnswers + count, forKey: Keys.correct.rawValue)
    userDefaults.set(totalQuestions + amount, forKey: Keys.total.rawValue)

    
    let currentGameResults = GameRecord(correct: count, total: amount, date: Date())
    if bestGame < currentGameResults {
      bestGame = currentGameResults
    }
  }
  
  private enum Keys: String {
      case correct, total, bestGame, gamesCount
  }
  
}
