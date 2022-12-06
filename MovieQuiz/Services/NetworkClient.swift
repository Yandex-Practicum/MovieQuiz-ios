import Foundation

struct NetworkClient: NetworkRouting {
    typealias Handler = (Result<Data, Errors>) -> Void

    func fetch(url: URL, handler: @escaping Handler) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                handler(.failure(Errors.offline))
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(Errors.invalidResponse))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
