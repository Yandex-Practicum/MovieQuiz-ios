import Foundation

protocol StatisticService {
    func store(correct: Int, total: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: BestGame? { get }
}

final class StatisticServiceImpl {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private var userDefaults = UserDefaults.standard
    private let dateProvider: () -> Date
    
    
    init
    (userDefaults: UserDefaults,
     decoder: JSONDecoder = JSONDecoder(),
     encoder: JSONEncoder = JSONEncoder(),
     dateProvider: @escaping () -> Date = { Date () }
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}
 
extension StatisticServiceImpl: StatisticService {
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
       Double(correct) / Double(total) * 100
    }
    
            var bestGame: BestGame? {
                get {
                    guard
                        let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                        let bestGame = try? decoder.decode(BestGame.self, from: data) else {
                        return nil
                    }
                    return bestGame
                }
                
                set {
                    let data = try? encoder.encode(newValue)
                    userDefaults.set(data, forKey: Keys.bestGame.rawValue)
                }
            }
            
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvider()
        let currentBestGame = BestGame (correct: correct, total: total, date: date)
        
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
                    bestGame = currentBestGame
            }
        }
}
