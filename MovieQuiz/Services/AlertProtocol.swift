import UIKit
protocol AlertProtocol {
    func showAlert(quiz result: AlertModel)
}

public struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
