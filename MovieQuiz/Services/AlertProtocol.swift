import UIKit
protocol AlertProtocol {
    func configure(model: AlertModel)
}

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
