import UIKit

struct AlertModel{
    let title :String
    let message :String
    let buttonText :String
    func completion(closure: () -> Void) {}
}
