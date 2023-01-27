

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present( _ viewControllerToPresent: UIViewController,
                  animated flag: Bool,
                  completion: (() -> Void)?)
}
