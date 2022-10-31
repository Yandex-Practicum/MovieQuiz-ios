import Foundation
import UIKit

extension UIStackView {
    // extension to add multiple arranged subviews (as Variadic parameters)
    func addArrangedSubViews( _ arrangedViews: UIView...) {
        for arrangedView in arrangedViews {
            addArrangedSubview(arrangedView)
        }
    }
}
