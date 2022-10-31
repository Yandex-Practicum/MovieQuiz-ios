import Foundation

struct AlertModel {
    let title: String
    let masseg: String
    let buttonText: String
    var completion: (() -> Void)?
}
