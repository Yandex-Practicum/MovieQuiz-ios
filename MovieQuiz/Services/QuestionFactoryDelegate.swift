
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
  func didRecieveNextQuestion(question: QuizQuestion?)
  func didLoadDataFromServer()
  func didFailToLoadData(with error: Error)
}
