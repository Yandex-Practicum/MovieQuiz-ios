import UIKit

extension UIImageView {
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.5 : 0.0
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionFlipFromLeft,
                          animations: { self.image = image },
                          completion: nil)
    }
}


