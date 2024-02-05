import Foundation

protocol AlertPresenterProtocol: AnyObject {
    var delegate: (AlertPresenterDelegate?) { get set }
    func show(alertModel: AlertModel)
}
