import Foundation
import UIKit

struct AlertModel{
    let alertTitle:String
    let alertMessage:String
    let alertButtonText:String
    let completion: ((UIAlertAction) -> Void)?
}
