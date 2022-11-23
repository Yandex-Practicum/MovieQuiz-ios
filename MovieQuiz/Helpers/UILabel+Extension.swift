import UIKit

extension UIView {
    func animateQuestion(animated: Bool = true) {
        let duration = animated ? 1 : 0.0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCurlUp,
                          animations: nil,
                          completion: nil)
    }
}

extension UIStackView {
    func animateImage(animated: Bool = true) {
        let duration = animated ? 1 : 0.0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCurlUp,
                          animations: nil,
                          completion: nil)
    }
}
extension Int {
    mutating func increment() {
        self += 1
    }
}
extension UInt8 {
    mutating func increment() {
        self += 1
    }
}
