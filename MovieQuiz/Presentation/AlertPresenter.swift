import Foundation
import UIKit

struct AlertPresenter {
   
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Methods
    
    func creationAlert(data alertModel: AlertModel?) {
      guard let alertModel = alertModel else { return }
         let alertController = UIAlertController(title: alertModel.title, message: alertModel.messange, preferredStyle: .alert)
         let alertAction = UIAlertAction(title: alertModel.buttonText, style: .default){ _ in
         guard let completion = alertModel.completion else {return}
                        completion()
            }
         alertController.addAction(alertAction)
         viewController?.present(alertController, animated: true, completion: nil)
    }
}
