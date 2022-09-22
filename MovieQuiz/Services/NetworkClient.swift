import Foundation
// отвечает за загрузку данных по ЮРЛ
// swiftlint: disable all
struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }

    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            // проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }

            //проверяем, что нам пришел успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }

            // Возвращаем данные
            guard let data = data else {return}
            handler(.success(data))
        }
        task.resume()
    }
}
