import Foundation
import UIKit
struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
