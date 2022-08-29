import UIKit

class ResultAlertPresenter {

    private let title: String
    private let message: String
    private let controller: UIViewController
    private let actionHandlder: ((UIAlertAction) -> Void)?

    init(
        title: String,
        message: String,
        controller: UIViewController,
        actionHandler: @escaping ((UIAlertAction) -> Void)
    ) {
        self.title = title
        self.message = message
        self.controller = controller
        self.actionHandlder = actionHandler
    }

    func show() {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Новая игра",
            style: .default,
            handler: {
                action in self.actionHandlder?(action)
            })

        alert.addAction(action)
        self.controller.present(alert, animated: true, completion: nil)
    }
}
