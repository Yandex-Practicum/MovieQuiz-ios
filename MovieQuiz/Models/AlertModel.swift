import UIKit
struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var buttonAction: (() -> Void)
}
