

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    let completion: (() -> Void)
}
