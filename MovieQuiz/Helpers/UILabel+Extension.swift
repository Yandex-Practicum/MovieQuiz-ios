import UIKit

extension UILabel {
    func setText(_ text: String, animated: Bool = true) {
        let duration = animated ? 0.5 : 0.0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionFlipFromLeft,
                          animations: { self.text = text },
                          completion: nil)
    }
}
