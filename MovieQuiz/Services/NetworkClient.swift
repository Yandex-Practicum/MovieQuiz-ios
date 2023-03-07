import Foundation

// Отвечает за загрузку данных по URL
struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // Проверяем, что нам пришел успешный код ответа
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                handler(.failure(NetworkError.codeError))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
