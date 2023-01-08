import Foundation

struct AlertModel {     // Структура для Алерта
  let title: String
  let message: String
  let buttonText: String
  let completion: ()->Void
}
