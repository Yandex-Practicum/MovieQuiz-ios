import Foundation

// MARK: - AlertModel

struct AlertModel {
    let title: String
    let messange: String
    let buttonText: String
    let completion: (() -> Void)?
}
