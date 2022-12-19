import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
