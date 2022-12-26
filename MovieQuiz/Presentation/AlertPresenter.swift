import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    private weak var controller: UIViewController?

    init(controller: UIViewController) {
        self.controller = controller
    }

    func showAlert(result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default,
            handler: { _ in result.completion() }
        )

        alert.addAction(action)
        
        controller?.present(alert, animated: true, completion: nil)

    }
}
