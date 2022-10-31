import UIKit
import Foundation

extension UIView { // extension for safe area
  var safeTopAnchor: NSLayoutYAxisAnchor {
      return safeAreaLayoutGuide.topAnchor
  }
  var safeLeadingAnchor: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
}
  var safeTrailingAnchor: NSLayoutXAxisAnchor {
    return safeAreaLayoutGuide.trailingAnchor
}
  var safeBottomAnchor: NSLayoutYAxisAnchor {
      return safeAreaLayoutGuide.bottomAnchor
  }
}
